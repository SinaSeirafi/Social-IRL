import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../entities/social_event.dart';

abstract class AbsSocialEventRepository {
  Future<Either<Failure, SocialEvent>> getSingleSocialEventById(int id);

  Future<Either<Failure, List<SocialEvent>>> getSocialEventList();

  Future<Either<Failure, int>> getSocialEventsCount();

  Future<Either<Failure, List<SocialEvent>>> addSocialEvent(
      SocialEvent socialEvent);

  Future<Either<Failure, List<SocialEvent>>> editSocialEvent(
      SocialEvent socialEvent);

  Future<Either<Failure, List<SocialEvent>>> deleteSocialEvent(
      SocialEvent socialEvent);

  Future<Either<Failure, List<SocialEvent>>> handlePersonRemoved(
      SocialEvent socialEvent);
}
