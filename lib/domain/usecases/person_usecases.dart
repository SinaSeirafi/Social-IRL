import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/failures.dart';
import '../../data/repositories/person_repository.dart';
import '../entities/person.dart';

abstract class PersonUsecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class Params extends Equatable {
  final Person person;

  const Params(this.person);

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

class AddPerson extends PersonUsecase<List<Person>, Params> {
  @override
  Future<Either<Failure, List<Person>>> call(Params params) async {
    params.person.createdAt = params.person.modifiedAt = DateTime.now();

    return await _repository.addPerson(params.person);
  }
}

class EditPerson extends PersonUsecase<List<Person>, Params> {
  @override
  Future<Either<Failure, List<Person>>> call(Params params) async {
    params.person.modifiedAt = DateTime.now();

    return await _repository.editPerson(params.person);
  }
}

class RemovePerson extends PersonUsecase<List<Person>, Params> {
  @override
  Future<Either<Failure, List<Person>>> call(Params params) async {
    params.person.modifiedAt = DateTime.now();

    params.person.isDeleted = true;

    return await _repository.deletePerson(params.person);
  }
}
