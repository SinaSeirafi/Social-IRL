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
  /// This is received in order to call [RemovePersonEvent] event on [SocialEventBloc]
  final BuildContext context;

  final Person person;

  const RemovePersonEvent(this.context, this.person);

  @override
  List<Object> get props => [Person];
}

class PersonEventUpdated extends PersonEvent {
  final Person person;
  final SocialEvent event;

  const PersonEventUpdated(this.person, this.event);

  @override
  List<Object> get props => [Person];
}
