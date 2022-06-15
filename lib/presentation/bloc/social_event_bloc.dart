import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:social_irl/domain/usecases/person_usecases.dart';
import 'package:social_irl/presentation/bloc/person_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/usecases/social_event_usecases.dart';

part 'social_event_event.dart';
part 'social_event_state.dart';

_emitLoading(emit) => emit(const SocialEventLoading());

class SocialEventBloc extends Bloc<SocialEventEvent, SocialEventState> {
  final GetSocialEventList _getSocialEventList = GetSocialEventList();
  final AddSocialEventUsecase _addSocialEventUsecase = AddSocialEventUsecase();
  final EditSocialEventUsecase _editSocialEventUsecase =
      EditSocialEventUsecase();
  final RemoveSocialEventUsecase _removeSocialEventUsecase =
      RemoveSocialEventUsecase();

  SocialEventBloc() : super(SocialEventInitial()) {
    on<LoadSocialEventData>((event, emit) async {
      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _getSocialEventList(NoParams()),
          "Get socialEvent list error.",
        ),
      );
    });

    on<AddSocialEventEvent>((event, emit) async {
      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _addSocialEventUsecase(SocialEventParams(event.socialEvent)),
          "Add socialEvent list error.",
        ),
      );
    });

    on<EditSocialEventEvent>((event, emit) async {
      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _editSocialEventUsecase(SocialEventParams(
            event.socialEvent,
            removedPeople: event.removedPeople,
          )),
          "Edit socialEvent list error.",
        ),
      );
    });

    on<RemoveSocialEventEvent>((event, emit) async {
      // final state = this.state as SocialEventLoaded;

      for (var person in event.socialEvent.attendees) {
        // Remove event from person and call EditPerson
        person.socialEvents.remove(event.socialEvent);

        // handles its own loading, no need to await it
        event.context.read<PersonBloc>().add(EditPersonEvent(person));
      }

      event.socialEvent.isDeleted = true;

      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _removeSocialEventUsecase(SocialEventParams(event.socialEvent)),
          "Delete socialEvent list error.",
        ),
      );
    });

    // /// When a [Person] is removed from a specific social event
    // on<RemovePersonFromSocialEvent>((event, emit) async {
    //   // Remove event from person and call EditPerson
    //   event.person.socialEvents.remove(event.socialEvent);

    //   // handles its own loading, no need to await it
    //   event.context.read<PersonBloc>().add(EditPersonEvent(event.person));

    //   // Remove person from event attendees and call EditSocialEvent
    //   event.socialEvent.attendees.remove(event.person);

    //   _emitLoading(emit);

    //   emit(
    //     _eitherLoadedOrErrorState(
    //       await _editSocialEventUsecase(Params(event.socialEvent)),
    //       "Edit socialEvent list error.",
    //     ),
    //   );
    // });

    /// When a [Person] is removed, remove it from all of the social events
    /// Also, if a [SocialEvent] only included that person, it should be removed as well
    on<HandleSocialEventsInCaseOfPersonRemoved>((event, emit) async {
      // TODO: implement event handler
    });
  }

  SocialEventState _eitherLoadedOrErrorState(
    Either<Failure, List<SocialEvent>> failureOrLoaded,
    String errorMessage,
  ) {
    return failureOrLoaded.fold(
      (failure) => SocialEventError(errorMessage),
      (socialEventsList) => SocialEventLoaded(events: socialEventsList),
    );
  }
}
