import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/extract_data_from_notes.dart';
import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/social_event_repository.dart';
import '../../presentation/widgets/notes_suggester.dart';
import '../entities/social_event.dart';
import '../entities/tag.dart';
import 'person_usecases.dart';

abstract class SocialEventUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class Params extends Equatable {
  final SocialEvent socialEvent;

  const Params(this.socialEvent);

  @override
  List<Object?> get props => [socialEvent];
}

class GetSocialEventList
    extends SocialEventUseCase<List<SocialEvent>, NoParams> {
  final SocialEventRepository _repository = SocialEventRepository.instance;

  @override
  Future<Either<Failure, List<SocialEvent>>> call(NoParams params) async {
    return await _repository.getSocialEventList();
  }
}

class AddSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, Params> {
  final SocialEventRepository _repository = SocialEventRepository.instance;

  @override
  Future<Either<Failure, List<SocialEvent>>> call(Params params) async {
    params.socialEvent.createdAt =
        params.socialEvent.modifiedAt = DateTime.now();

    for (var person in params.socialEvent.attendees) {
      person.socialEvents.add(params.socialEvent);

      EditPerson editPerson = EditPerson();

      await editPerson(PersonParams(person));
    }

    return await _repository.addSocialEvent(params.socialEvent);
  }
}

class EditSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, Params> {
  final SocialEventRepository _repository = SocialEventRepository.instance;

  @override
  Future<Either<Failure, List<SocialEvent>>> call(Params params) async {
    params.socialEvent.modifiedAt = DateTime.now();

    return await _repository.editSocialEvent(params.socialEvent);
  }
}

class RemoveSocialEventUsecase
    extends SocialEventUseCase<List<SocialEvent>, Params> {
  final SocialEventRepository _repository = SocialEventRepository.instance;

  @override
  Future<Either<Failure, List<SocialEvent>>> call(Params params) async {
    params.socialEvent.modifiedAt = DateTime.now();

    params.socialEvent.isDeleted = true;

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
      socialEvent.tags.add(SocialEventTag(id: 0, title: item));
    }
  }
}
