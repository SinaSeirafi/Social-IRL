import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_irl/domain/usecases/person_usecases.dart';

import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../data/repositories/social_event_repository.dart';
import '../entities/social_event.dart';

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
