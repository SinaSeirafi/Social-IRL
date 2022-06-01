import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/data/datasources/dummyData.dart';
import 'package:social_irl/data/repositories/person_repository.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/presentation/bloc/person_bloc.dart';
import 'package:social_irl/presentation/bloc/social_event_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  // Test data
  Person person = Person(
    id: 0,
    name: "name",
    socialCircle: dummySocialCircle1,
  );
  SocialEvent socialEvent = SocialEvent(
    id: 0,
    startDate: DateTime.now(),
    attendees: [person],
  );

  MockBuildContext _mockContext = MockBuildContext();

  PersonBloc personBloc = PersonBloc();
  SocialEventBloc socialEventBloc = SocialEventBloc();

// TODO: check after adding database
  int defaultDelay =
      demoMode ? PersonRepository.demoModeDelayInMilliSeconds * 3 : 10;
  int loadingDelay = defaultDelay ~/ 3;

  Future<void> _delay([int? delay]) async {
    await Future.delayed(Duration(milliseconds: delay ?? defaultDelay));
  }

  blocTest<PersonBloc, PersonState>(
    'Emits "Loading" & "Loaded" after LoadEvent',
    build: () => PersonBloc(),
    act: (bloc) => bloc.add(const LoadPersonData()),
    wait: Duration(milliseconds: defaultDelay),
    expect: () => const <PersonState>[
      PersonLoading(),
      PersonLoaded(persons: []),
    ],
  );

  test("Add a person", () async {
    personBloc.add(const LoadPersonData());
    expect(personBloc.state, PersonInitial());

    await _delay(loadingDelay);
    expect(personBloc.state.runtimeType, PersonLoading);

    await _delay();
    expect(personBloc.state.runtimeType, PersonLoaded);

    var state = personBloc.state as PersonLoaded;

    int count = state.persons.length;

    personBloc.add(AddPersonEvent(person));

    await _delay(loadingDelay);
    expect(personBloc.state.runtimeType, PersonLoading);

    await _delay();
    expect(personBloc.state.runtimeType, PersonLoaded);

    state = personBloc.state as PersonLoaded;

    expect(state.persons.length, count + 1);

    // Removing the added person
    personBloc.add(RemovePersonEvent(_mockContext, person));
  });

  test('Removing a person', () async {
    personBloc.add(const LoadPersonData());
    socialEventBloc.add(const LoadSocialEventData());

    await _delay();

    var state = personBloc.state as PersonLoaded;

    int count = state.persons.length;

    personBloc.add(AddPersonEvent(person));
    await _delay();

    state = personBloc.state as PersonLoaded;

    expect(state.persons.length, count + 1);

    socialEventBloc.add(AddSocialEventEvent(socialEvent));
    await _delay();

    // TODO: add social event to person.socialEvents
    // expect(person.socialEvents.contains(socialEvent), true);

    personBloc.add(RemovePersonEvent(_mockContext, person));
    await _delay();

    state = personBloc.state as PersonLoaded;

    expect(state.persons.length, count);

    /// on [RemovePersonEvent] check
    for (SocialEvent socialEvent in person.socialEvents) {
      expect(socialEvent.attendees.contains(person), false);
    }
  });
}
