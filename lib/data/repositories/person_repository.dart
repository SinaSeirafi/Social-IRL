import 'package:dartz/dartz.dart';
import 'package:social_irl/data/datasources/dummyData.dart';

import '../../core/failures.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/abs_person_repository.dart';
// import '../datasources/Person_database.dart';

class PersonRepository implements AbsPersonRepository {
  static final PersonRepository _instance = PersonRepository();
  static PersonRepository get instance => _instance;

  // final DatabaseHelper databaseHelper = DatabaseHelper();

  // List<Person> personsDataList = [dummyPerson1, dummyPerson2];
  List<Person> personsDataList = [];

  static const int demoModeDelayInMilliSeconds = 30;

  _demoModeDelay() async {
    await Future.delayed(
      const Duration(milliseconds: demoModeDelayInMilliSeconds),
    );
  }

  @override
  Future<Either<Failure, List<Person>>> getPersonList() async {
    try {
      // List<Person> PersonsDataList = await databaseHelper.getPersonList();
      // TODO: implement database version

      // Demo mode implementation
      await _demoModeDelay();
      return Right(personsDataList);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Person>>> addPerson(Person person) async {
    try {
      // print("Add Person Repo started");
      // TODO: implement database version
      // bool success = await databaseHelper.insertPerson(person) != 0;

      // print("Add Person success: $success");
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      await _demoModeDelay();
      personsDataList.add(person);

      return getPersonList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Person>>> editPerson(Person person) async {
    try {
      // TODO: implement database version
      // bool success = await databaseHelper.updatePerson(person) != 0;
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      await _demoModeDelay();
      int index =
          personsDataList.indexWhere((element) => element.id == person.id);
      personsDataList[index] = person;

      return getPersonList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Person>>> deletePerson(Person person) async {
    try {
      // print("Delete Person Repo started");

      // TODO: implement database version
      // bool success = await databaseHelper.deletePerson(person) != 0;
      // print("Delete Person success: $success");
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      await _demoModeDelay();
      personsDataList.removeWhere((element) => element.id == person.id);

      return getPersonList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getPersonsCount() async {
    try {
      // TODO: implement database version
      // int count = await databaseHelper.getPersonsCount();

      // Demo mode implementation
      await _demoModeDelay();
      return Right(personsDataList.length);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Person>> getSinglePersonById(int id) async {
    // TODO: implement getSinglePersonById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Person>>> personEventUpdated(Person person) {
    // TODO: implement personEventUpdated
    throw UnimplementedError();
  }
}
