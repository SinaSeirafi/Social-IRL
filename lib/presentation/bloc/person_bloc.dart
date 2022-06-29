import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/failures.dart';
import '../../core/usecases.dart';
import '../../domain/entities/person.dart';
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

        event.person.isDeleted = true;

        emit(
          _eitherLoadedOrErrorState(
            await _removePerson(PersonParams(event.person)),
            "Delete person error.",
          ),
        );
      }
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
