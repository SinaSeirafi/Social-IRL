import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/app_constants.dart';
import '../../core/cn_helper.dart';
import '../../core/extract_data_from_notes.dart';
import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/person_repository.dart';
import '../../presentation/widgets/notes_suggester.dart';
import '../entities/person.dart';
import '../entities/tag.dart';
import 'mediator_person_social.dart';

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
    return await _repository.getPersonList();
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

/// Steps
///
/// 1. Set [person.isDeleted] = true
/// 2. Mediator.handlePersonRemoved
///   - Remove Person from Events
///   - Remove Events from Person
/// 3. Edit events
///   - Update persons
/// for the removed person,
class RemovePerson extends PersonUsecase<List<Person>, PersonParams> {
  @override
  Future<Either<Failure, List<Person>>> call(PersonParams params) async {
    params.person.modifiedAt = DateTime.now();

    params.person.isDeleted = true;

    await MediatorPersonSocialEvent.handleSocialEventsAfterPersonRemoved(
        params.person);

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
    target.socialEventIds = source.socialEventIds;
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
}
