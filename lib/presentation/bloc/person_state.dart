part of 'person_bloc.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object> get props => [];
}

class PersonInitial extends PersonState {}

class Loading extends PersonState {
  const Loading();
}

class PersonLoaded extends PersonState {
  final List<Person> persons;

  const PersonLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class PersonError extends PersonState {
  final String message;

  const PersonError(this.message);

  @override
  List<Object> get props => [message];
}
