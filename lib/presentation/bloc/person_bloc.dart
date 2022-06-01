import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/presentation/bloc/social_event_bloc.dart';

import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/usecases/person_usecases.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  // Usecases
  final GetPersonList _getPersonList = GetPersonList();
  final AddPerson _addPerson = AddPerson();
  final EditPerson _editPerson = EditPerson();
  final RemovePerson _removePerson = RemovePerson();

  _emitLoading(emit) => emit(const PersonLoading());

  PersonBloc() : super(PersonInitial()) {
    on<LoadPersonData>((event, emit) async {
      _emitLoading(emit);

      emit(
        _eitherLoadedOrErrorState(
          await _getPersonList(NoParams()),
          // future.first,
          "Get person list error.",
        ),
      );
    });

    on<AddPersonEvent>((event, emit) async {
      // TODO: check if we can remove all of these state checks here
      if (state is PersonLoaded) {
        _emitLoading(emit);

        emit(
          _eitherLoadedOrErrorState(
            await _addPerson(PersonParams(event.person)),
            "Add person error.",
          ),
        );
      }
    });

    on<EditPersonEvent>((event, emit) async {
      if (state is PersonLoaded) {
        _emitLoading(emit);

        emit(
          _eitherLoadedOrErrorState(
            await _editPerson(PersonParams(event.person)),
            "Edit person error.",
          ),
        );
      }
    });

    on<RemovePersonEvent>((event, emit) async {
      if (state is PersonLoaded) {
        _emitLoading(emit);
        // final state = this.state as PersonLoaded;

        /// Check related events being updated
        /// This should be called
        /// Maybe update using
        /// https://stackoverflow.com/questions/67540291/is-it-allowed-to-add-event-to-another-bloc-from-inside-of-a-bloc
        /// or
        /// https://medium.com/flutter-community/flutter-design-patterns-22-mediator-575e7aa6bfa9
        for (SocialEvent socialEvent in event.person.socialEvents) {
          /// This can also receive [socialEventBloc] and work with that
          /// like this:
          /// [Bloc socialEventBloc = SocialEventBloc();]
          /// instead of context
          ///
          /// FIXME: does it need a listener here in order to ... await the removal
          event.context.read<SocialEventBloc>().add(
              HandleSocialEventsInCaseOfPersonRemoved(
                  socialEvent, event.person));
        }

        event.person.isDeleted = true;

        Either<Failure, List<Person>> failureOrPersonList =
            await _removePerson(PersonParams(event.person));

        emit(
          _eitherLoadedOrErrorState(
            failureOrPersonList,
            "Delete person error.",
          ),
        );
      }
    });

    /// When a [SocialEvent] is updated that affects a person
    /// SocialEvent Add/Edit/Delete should be handled here
    on<PersonEventUpdated>((event, emit) async {
      // TODO: implement event handler
    });
  }

  PersonState _eitherLoadedOrErrorState(
    Either<Failure, List<Person>> failureOrLoaded,
    String errorMessage,
  ) {
    return failureOrLoaded.fold(
      (failure) => PersonError(errorMessage),
      (personList) => PersonLoaded(persons: personList),
    );
  }
}
