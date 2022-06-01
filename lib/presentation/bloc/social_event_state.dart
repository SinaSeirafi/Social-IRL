part of 'social_event_bloc.dart';

abstract class SocialEventState extends Equatable {
  const SocialEventState();

  @override
  List<Object> get props => [];
}

class SocialEventInitial extends SocialEventState {}

class SocialEventLoading extends SocialEventState {
  const SocialEventLoading();
}

class SocialEventLoaded extends SocialEventState {
  final List<SocialEvent> events;

  const SocialEventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class SocialEventError extends SocialEventState {
  final String message;

  const SocialEventError(this.message);

  @override
  List<Object> get props => [message];
}
