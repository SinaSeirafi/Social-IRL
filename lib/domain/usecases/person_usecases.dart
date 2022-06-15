import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/core/extract_data_from_notes.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/tag.dart';
import 'package:social_irl/presentation/widgets/notes_suggester.dart';

import '../../core/cn_helper.dart';
import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/person_repository.dart';
import '../entities/person.dart';

abstract class PersonUsecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class PersonParams extends Equatable {
  final Person person;

  const PersonParams(this.person);

  @override
  List<Object?> get props => [person];
}

final PersonRepository _repository = PersonRepository.instance;

class GetPersonList extends PersonUsecase<List<Person>, NoParams> {
  @override
  Future<Either<Failure, List<Person>>> call(NoParams params) async {
    Either<Failure, List<Person>> personListOrFailure =
        await _repository.getPersonList();

    return personListOrFailure;
  }
}

class AddPerson extends PersonUsecase<List<Person>, PersonParams> {
  @override
  Future<Either<Failure, List<Person>>> call(PersonParams params) async {
    params.person.createdAt = params.person.modifiedAt = DateTime.now();

    return await _repository.addPerson(params.person);
  }
}

class EditPerson extends PersonUsecase<List<Person>, PersonParams> {
  @override
  Future<Either<Failure, List<Person>>> call(PersonParams params) async {
    params.person.modifiedAt = DateTime.now();

    params.person.updateNextAndLastSocialEventTimes();

    return await _repository.editPerson(params.person);
  }
}

class RemovePerson extends PersonUsecase<List<Person>, PersonParams> {
  @override
  Future<Either<Failure, List<Person>>> call(PersonParams params) async {
    params.person.modifiedAt = DateTime.now();

    params.person.isDeleted = true;

    return await _repository.deletePerson(params.person);
  }
}

class PersonGeneralUsecases {
  static void copyDataFromPerson(Person source, Person target) {
    target.name = source.name;
    target.socialCircle = source.socialCircle;
    target.potentialForCircle = source.potentialForCircle;
    target.notes = source.notes;
    target.tags = source.tags;
    target.socialEvents = source.socialEvents;
    target.isDeleted = source.isDeleted;
    target.createdAt = source.createdAt;
    target.modifiedAt = source.modifiedAt;
  }

  static void setPersonTagsBasedOnNotes(Person person) {
    person.tags = [];

    List<String> tagStrings = extractDataFromNotes(person.notes, tagPattern);

    for (var item in tagStrings) {
      if (item.isEmpty) continue;

      PersonTag tag = PersonTag(id: 0, title: item);

      person.tags.add(tag);
      allPersonTags.add(tag);
    }
  }

  static String timeSinceLastEvent(Person person) {
    String startText = "Last Event: ";

    if (person.lastSocialEvent == null) return startText + "Never 😬";

    return startText + (h.timePassed(person.lastSocialEvent!) ?? "Just Now");
  }

  /// Updaing [nextSocialEvent] and [lastSocialEvent] values
  ///
  /// This can be called after adding, editing, or deleting a social event
  static void updateNextAndLastSocialEventTimes(Person person) {
    if (person.socialEvents.isEmpty) {
      person.nextSocialEvent = null;
      person.lastSocialEvent = null;
    }

    for (var event in person.socialEvents) {
      if (event.startDate.isAfter(DateTime.now())) {
        if (person.nextSocialEvent == null ||
            event.startDate.isBefore(person.nextSocialEvent!)) {
          person.nextSocialEvent = event.startDate;
        }
        continue;
      }

      if (person.lastSocialEvent == null ||
          event.startDate.isAfter(person.lastSocialEvent!)) {
        person.lastSocialEvent = event.startDate;
      }
    }
  }

  static final EditPerson _editPerson = EditPerson();

  static Future addSocialEventToPerson(
      Person person, SocialEvent socialEvent) async {
    person.socialEvents.add(socialEvent);

    await _editPerson(PersonParams(person));
  }

  static Future updatePersonSocialEvent(
      Person person, SocialEvent socialEvent) async {
    int index = person.socialEvents
        .indexWhere((element) => element.id == socialEvent.id);

    person.socialEvents[index] = socialEvent;

    await _editPerson(PersonParams(person));
  }

  static Future removeSocialEventFromPerson(
      Person person, SocialEvent socialEvent) async {
    person.socialEvents.removeWhere((element) => element.id == socialEvent.id);

    await _editPerson(PersonParams(person));
  }
}
