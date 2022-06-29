import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/app_constants.dart';
import '../../core/extract_data_from_notes.dart';
import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/social_event_repository.dart';
import '../../presentation/widgets/notes_suggester.dart';
import '../entities/social_event.dart';
import '../entities/tag.dart';
import 'mediator_person_social.dart';

abstract class SocialEventUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class SocialEventParams extends Equatable {
  final SocialEvent socialEvent;

  /// People that are removed from the event while editing the event
  final List? removedPeople;

  const SocialEventParams(this.socialEvent, {this.removedPeople});

  @override
  List<Object?> get props => [socialEvent];
}

final SocialEventRepository _repository = SocialEventRepository.instance;

class GetSocialEventList
    extends SocialEventUseCase<List<SocialEvent>, NoParams> {
  @override
  Future<Either<Failure, List<SocialEvent>>> call(NoParams params) async {
    return await _repository.getSocialEventList();
  }
}

class AddSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, SocialEventParams> {
  @override
  Future<Either<Failure, List<SocialEvent>>> call(
      SocialEventParams params) async {
    params.socialEvent.createdAt =
        params.socialEvent.modifiedAt = DateTime.now();

    await MediatorPersonSocialEvent.addSocialEventToNewAttendees(
        params.socialEvent);

    return await _repository.addSocialEvent(params.socialEvent);
  }
}

class EditSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, SocialEventParams> {
  @override
  Future<Either<Failure, List<SocialEvent>>> call(
      SocialEventParams params) async {
    params.socialEvent.modifiedAt = DateTime.now();

    await MediatorPersonSocialEvent.handleAttendeesAfterSocialEventEdit(
        params.removedPeople, params.socialEvent);

    // first updating the data on the social event (removing people or ...)
    var editResult = await _repository.editSocialEvent(params.socialEvent);

    // // if failed, or still has attendees, return edit result
    if (editResult.isLeft() || params.socialEvent.attendees.isNotEmpty) {
      return editResult;
    }

    // it doesn't have any attendees left, delete it
    final _removeSocialEvent = RemoveSocialEventUsecase();
    return await _removeSocialEvent(SocialEventParams(params.socialEvent));
  }
}

class RemoveSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, SocialEventParams> {
  @override
  Future<Either<Failure, List<SocialEvent>>> call(
      SocialEventParams params) async {
    params.socialEvent.modifiedAt = DateTime.now();

    params.socialEvent.isDeleted = true;

    await MediatorPersonSocialEvent.removeSocialEventFromPersonList(
        params.socialEvent);

    return await _repository.deleteSocialEvent(params.socialEvent);
  }
}

class SocialEventGeneralUsecases {
  static void copyDataFromSocialEvent(SocialEvent source, SocialEvent target) {
    target.title = source.title;
    target.startDate = source.startDate;
    target.endDate = source.endDate;
    target.attendees = source.attendees;
    target.notes = source.notes;
    target.tags = source.tags;
    target.isDeleted = source.isDeleted;
    target.createdAt = source.createdAt;
    target.modifiedAt = source.modifiedAt;
  }

  static void setSocialEventTagsBasedOnNotes(SocialEvent socialEvent) {
    socialEvent.tags = [];

    List<String> tagStrings =
        extractDataFromNotes(socialEvent.notes, tagPattern);

    for (var item in tagStrings) {
      if (item.isEmpty) continue;

      SocialEventTag tag = SocialEventTag(id: 0, title: item);

      socialEvent.tags.add(tag);
      allSocialEventTags.add(tag);
    }
  }
}
