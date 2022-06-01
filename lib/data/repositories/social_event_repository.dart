import 'package:dartz/dartz.dart';
import 'package:social_irl/data/datasources/dummyData.dart';

import '../../core/failures.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/repositories/abs_social_event_repository.dart';
// import '../datasources/SocialEvent_database.dart';

class SocialEventRepository implements AbsSocialEventRepository {
  static final SocialEventRepository _instance = SocialEventRepository();
  static SocialEventRepository get instance => _instance;

  // final DatabaseHelper databaseHelper = DatabaseHelper();

  List<SocialEvent> socialEventsDataList = [dummySocialEvent1];

  @override
  Future<Either<Failure, List<SocialEvent>>> getSocialEventList() async {
    try {
      // List<SocialEvent> SocialEventsDataList = await databaseHelper.getSocialEventList();
      // TODO: implement database version

      // Demo mode implementation
      return Right(socialEventsDataList);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<SocialEvent>>> addSocialEvent(
      SocialEvent socialEvent) async {
    try {
      // print("Add SocialEvent Repo started");
      // TODO: implement database version
      // bool success = await databaseHelper.insertSocialEvent(socialEvent) != 0;

      // print("Add SocialEvent success: $success");
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      socialEventsDataList.add(socialEvent);

      return getSocialEventList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<SocialEvent>>> editSocialEvent(
      SocialEvent socialEvent) async {
    try {
      // TODO: implement database version
      // bool success = await databaseHelper.updateSocialEvent(socialEvent) != 0;
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      int index = socialEventsDataList
          .indexWhere((element) => element.id == socialEvent.id);
      socialEventsDataList[index] = socialEvent;

      return getSocialEventList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<SocialEvent>>> deleteSocialEvent(
      SocialEvent socialEvent) async {
    try {
      // print("Delete SocialEvent Repo started");

      // TODO: implement database version
      // bool success = await databaseHelper.deleteSocialEvent(socialEvent) != 0;
      // print("Delete SocialEvent success: $success");
      // if (!success) return Left(DatabaseFailure());

      // Demo mode implementation
      socialEventsDataList
          .removeWhere((element) => element.id == socialEvent.id);

      return getSocialEventList();
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getSocialEventsCount() async {
    try {
      // TODO: implement database version
      // int count = await databaseHelper.getSocialEventsCount();

      // Demo mode implementation
      return Right(socialEventsDataList.length);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, SocialEvent>> getSingleSocialEventById(int id) async {
    // TODO: implement getSingleSocialEventById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SocialEvent>>> SocialEventEventUpdated(
      SocialEvent socialEvent) {
    // TODO: implement SocialEventEventUpdated
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SocialEvent>>> handlePersonRemoved(
      SocialEvent socialEvent) {
    // TODO: implement handlePersonRemoved
    throw UnimplementedError();
  }
}
