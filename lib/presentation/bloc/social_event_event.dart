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
  final List<Person> removedPeople;

  const EditSocialEventEvent(
    this.socialEvent, {
    this.removedPeople = const [],
  });

  @override
  List<Object> get props => [socialEvent];
}

class RemoveSocialEventEvent extends SocialEventEvent {
  final SocialEvent socialEvent;

  const RemoveSocialEventEvent(this.socialEvent);

  @override
  List<Object> get props => [socialEvent];
}
