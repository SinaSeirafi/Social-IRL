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
  List<Object> get props => [socialEvent];
}

class EditSocialEventEvent extends SocialEventEvent {
  final SocialEvent socialEvent;

  const EditSocialEventEvent(this.socialEvent);

  @override
  List<Object> get props => [socialEvent];
}

class RemoveSocialEventEvent extends SocialEventEvent {
  final BuildContext context;
  final SocialEvent socialEvent;

  const RemoveSocialEventEvent(this.context, this.socialEvent);

  @override
  List<Object> get props => [socialEvent];
}

class RemovePersonFromSocialEvent extends SocialEventEvent {
  final BuildContext context;
  final SocialEvent socialEvent;
  final Person person;

  const RemovePersonFromSocialEvent(
      this.context, this.socialEvent, this.person);

  @override
  List<Object> get props => [socialEvent];
}

class HandleSocialEventsInCaseOfPersonRemoved extends SocialEventEvent {
  final SocialEvent socialEvent;
  final Person person;

  const HandleSocialEventsInCaseOfPersonRemoved(this.socialEvent, this.person);

  @override
  List<Object> get props => [socialEvent];
}
