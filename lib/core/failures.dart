import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  /// later development
  /// Add fields, like error message or error code

  /// If the subclasses have some properties, they'll get passed to this constructor
  /// so that Equatable can perform value comparison.

  final List properties;

  const Failure([
    this.properties = const <dynamic>[],
  ]);

  @override
  List<Object?> get props => [properties];
}

/// general failures
class ServerFailure extends Failure {}

class DatabaseFailure extends Failure {}
