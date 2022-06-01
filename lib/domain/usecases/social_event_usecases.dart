import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/extract_data_from_notes.dart';
import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/social_event_repository.dart';
import '../../presentation/bloc/person_bloc.dart';
import '../../presentation/widgets/cn_widgets/cn_message.dart';
import '../../presentation/widgets/notes_suggester.dart';
import '../entities/person.dart';
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
      if (item.isEmpty) continue;

      socialEvent.tags.add(SocialEventTag(id: 0, title: item));
    }
  }

  static String? validateEventAttendees(
    List<Person> personsList,
    SocialEvent socialEvent,
    TextEditingController controller,
  ) {
    socialEvent.attendees = [];

    List<String> attendeesString =
        extractDataFromNotes(controller.text, attendeePattern);

    if (attendeesString.isEmpty) {
      return "So, it was a personal event? \nNot really social, is it? :D"
          "\n\nPlease add at least one attendee \n(type @name in the notes text box)";
    }

    // Checking each entry
    for (var item in attendeesString) {
      if (item.isEmpty) continue;

      // is .any() and .firstWhere() faster than this?
      bool found = false;

      for (var person in personsList) {
        if (person.name.toLowerCase() == item.toLowerCase()) {
          // FIXME: so ... what if two people have the same name? :D

          /// should be much more advanced and show possible options (if multiple)
          /// and user chooses between them
          /// but for now it can be enough

          socialEvent.attendees.add(person);
          found = true;
          break;
        }
      }

      if (!found) {
        return "Couldn't find '$item' in people"
            "\nPlease add them first.";
      }
    }

    return null;
  }
}
