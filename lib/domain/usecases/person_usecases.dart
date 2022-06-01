import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_irl/core/extract_data_from_notes.dart';
import 'package:social_irl/domain/entities/tag.dart';
import 'package:social_irl/presentation/widgets/notes_suggester.dart';

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
      person.tags.add(PersonTag(id: 0, title: item));
    }
  }
}
