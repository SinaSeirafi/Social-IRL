import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/failures.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/usecases/social_event_usecases.dart';

part 'social_event_event.dart';
part 'social_event_state.dart';

class SocialEventBloc extends Bloc<SocialEventEvent, SocialEventState> {
  final GetSocialEventList getSocialEventList = GetSocialEventList();
  final AddSocialEvent addSocialEvent = AddSocialEvent();
  final EditSocialEvent editSocialEvent = EditSocialEvent();
  final RemoveSocialEvent removeSocialEvent = RemoveSocialEvent();

  SocialEventBloc() : super(SocialEventInitial()) {
    on<LoadSocialEventData>((event, emit) async {
      Either<Failure, List<SocialEvent>> socialEventListOrFailure =
          await getSocialEventList(NoParams());

      socialEventListOrFailure.fold(
        (failure) {
          emit(const SocialEventError("Get socialEvent list error."));
          return;
        },
        (socialEventList) {
          emit(SocialEventLoaded(events: socialEventList));
        },
      );
    });

    on<AddSocialEventEvent>((event, emit) async {
      // TODO: check if we can remove all of these state checks here
      if (state is SocialEventLoaded) {
        Either<Failure, List<SocialEvent>> socialEventListOrFailure =
            await addSocialEvent(Params(event.socialEvent));

        socialEventListOrFailure.fold(
          (failure) {
            emit(const SocialEventError("Add socialEvent error."));
            return;
          },
          (socialEventList) {
            emit(SocialEventLoaded(events: socialEventList));
          },
        );
      }
    });

    on<EditSocialEventEvent>((event, emit) async {
      if (state is SocialEventLoaded) {
        Either<Failure, List<SocialEvent>> socialEventListOrFailure =
            await editSocialEvent(Params(event.socialEvent));

        socialEventListOrFailure.fold(
          (failure) {
            emit(const SocialEventError("Edit socialEvent error."));
            return;
          },
          (socialEventList) {
            emit(SocialEventLoaded(events: socialEventList));
          },
        );
      }
    });

    on<RemoveSocialEventEvent>((event, emit) async {
      if (state is SocialEventLoaded) {
        // final state = this.state as SocialEventLoaded;

        event.socialEvent.isDeleted = true;

        Either<Failure, List<SocialEvent>> socialEventListOrFailure =
            await removeSocialEvent(Params(event.socialEvent));

        socialEventListOrFailure.fold(
          (failure) {
            emit(const SocialEventError("Delete socialEvent error."));
            return;
          },
          (socialEventList) {
            emit(SocialEventLoaded(events: socialEventList));
          },
        );
      }
    });

    /// When a [Person] is removed, remove it from all of the social events
    /// Also, if a [SocialEvent] only included that person, it should be removed as well
    on<HandlePersonRemoved>((event, emit) async {
      // TODO: implement event handler
    });
  }
}
