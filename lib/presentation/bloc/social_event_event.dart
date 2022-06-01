part of 'social_event_bloc.dart';

abstract class SocialEventEvent extends Equatable {
  const SocialEventEvent();

  @override
  List<Object> get props => [];
}

class LoadSocialEventData extends SocialEventEvent {
  const LoadSocialEventData();

  @override
  List<Object> get props => [];
}

class AddSocialEventEvent extends SocialEventEvent {
  final SocialEvent socialEvent;

  const AddSocialEventEvent(this.socialEvent);

  @override
  List<Object> get props => [SocialEvent];
}

class EditSocialEventEvent extends SocialEventEvent {
  final SocialEvent socialEvent;

  const EditSocialEventEvent(this.socialEvent);

  @override
  List<Object> get props => [SocialEvent];
}

class RemoveSocialEventEvent extends SocialEventEvent {
  final SocialEvent socialEvent;

  const RemoveSocialEventEvent(this.socialEvent);

  @override
  List<Object> get props => [SocialEvent];
}

class HandlePersonRemoved extends SocialEventEvent {
  final SocialEvent socialEvent;
  final Person person;

  const HandlePersonRemoved(this.socialEvent, this.person);

  @override
  List<Object> get props => [SocialEvent];
}
