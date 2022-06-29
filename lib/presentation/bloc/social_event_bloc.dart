import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

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
      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _removeSocialEventUsecase(SocialEventParams(event.socialEvent)),
          "Delete socialEvent list error.",
        ),
      );
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
