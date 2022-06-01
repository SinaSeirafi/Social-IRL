import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../entities/person.dart';

abstract class AbsPersonRepository {
  Future<Either<Failure, Person>> getSinglePersonById(int id);

  Future<Either<Failure, List<Person>>> getPersonList();

  Future<Either<Failure, int>> getPersonsCount();

  Future<Either<Failure, List<Person>>> addPerson(Person person);

  Future<Either<Failure, List<Person>>> editPerson(Person person);

  Future<Either<Failure, List<Person>>> deletePerson(Person person);

  Future<Either<Failure, List<Person>>> personEventUpdated(Person person);
}
