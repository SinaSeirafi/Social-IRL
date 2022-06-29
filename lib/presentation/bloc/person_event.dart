part of 'person_bloc.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

class LoadPersonData extends PersonEvent {
  const LoadPersonData();

  @override
  List<Object> get props => [];
}

class AddPersonEvent extends PersonEvent {
  final Person person;

  const AddPersonEvent(this.person);

  @override
  List<Object> get props => [Person];
}

class EditPersonEvent extends PersonEvent {
  final Person person;

  const EditPersonEvent(this.person);

  @override
  List<Object> get props => [Person];
}

class RemovePersonEvent extends PersonEvent {
  final Person person;

  const RemovePersonEvent(this.person);

  @override
  List<Object> get props => [Person];
}
