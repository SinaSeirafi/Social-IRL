import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/domain/usecases/social_event_usecases.dart';

import '../../core/extract_data_from_notes.dart';
import '../entities/person.dart';
import '../entities/social_event.dart';
import 'person_usecases.dart';

class MediatorPersonSocialEvent {
  static final EditPerson _editPerson = EditPerson();
  static final EditSocialEventUsecase _editSocialEvent =
      EditSocialEventUsecase();

  static List<SocialEvent> getSocialEventsByIds(List<int> socialEventIds) {
    return allSocialEvents
        .where((element) => socialEventIds.contains(element.id))
        .toList()
        .cast<SocialEvent>();
  }

  /// Updaing [nextSocialEvent] and [lastSocialEvent] values
  ///
  /// This can be called after adding, editing, or deleting a social event
  static void updateNextAndLastSocialEventTimes(Person person) {
    if (person.socialEvents.isEmpty) {
      person.nextSocialEvent = null;
      person.lastSocialEvent = null;
      return;
    }

    for (var event in person.socialEvents) {
      if (event.startDate.isAfter(DateTime.now())) {
        if (person.nextSocialEvent == null ||
            event.startDate.isBefore(person.nextSocialEvent!)) {
          person.nextSocialEvent = event.startDate;
        }
        continue;
      }

      if (person.lastSocialEvent == null ||
          event.startDate.isAfter(person.lastSocialEvent!)) {
        person.lastSocialEvent = event.startDate;
      }
    }
  }

  static Future addSocialEventToNewAttendees(SocialEvent socialEvent) async {
    for (var person in socialEvent.attendees) {
      await addSocialEventToPerson(person, socialEvent);
    }
  }

  static Future addSocialEventToPerson(
      Person person, SocialEvent socialEvent) async {
    person.socialEventIds.add(socialEvent.id);

    await _editPerson(PersonParams(person));
  }

  static Future removeSocialEventFromPersonList(SocialEvent socialEvent) async {
    for (var person in socialEvent.attendees) {
      await removeSocialEventFromPerson(person, socialEvent);
    }
  }

  static Future removeSocialEventFromPerson(
      Person person, SocialEvent socialEvent) async {
    if (person.lastSocialEvent == socialEvent.startDate) {
      person.lastSocialEvent = null;
    }

    if (person.nextSocialEvent == socialEvent.startDate) {
      person.nextSocialEvent = null;
    }

    person.socialEventIds.removeWhere((element) => element == socialEvent.id);

    await _editPerson(PersonParams(person));
  }

  static Future handleSocialEventsAfterPersonRemoved(Person person) async {
    for (SocialEvent socialEvent in person.socialEvents) {
      socialEvent.attendees.remove(person);

      await _editSocialEvent(
          SocialEventParams(socialEvent, removedPeople: [person]));
    }
  }

  static Future handleAttendeesAfterSocialEventEdit(
    List? removedPeople,
    SocialEvent socialEvent,
  ) async {
    if (removedPeople != null) {
      await handleRemovedPeopleFromSocialEvent(
          removedPeople.cast<Person>(), socialEvent);
    }

    for (var person in socialEvent.attendees) {
      // Add or Update
      await handlePersonSocialEventAfterEdit(person, socialEvent);
    }
  }

  static Future handleRemovedPeopleFromSocialEvent(
    List<Person> removedPeople,
    SocialEvent socialEvent,
  ) async {
    for (var person in removedPeople) {
      await removeSocialEventFromPerson(person, socialEvent);
    }
  }

  /// If Person already has the event, ignore it
  /// If not, add it
  static Future handlePersonSocialEventAfterEdit(
      Person person, SocialEvent socialEvent) async {
    // person already has the event
    if (person.socialEventIds.any((element) => element == socialEvent.id)) {
      // social event already updated
      return;
    }

    await addSocialEventToPerson(person, socialEvent);
  }

  static String? validateEventAttendees(
    List<Person> personsList,
    SocialEvent socialEvent,
    String sourceText,
    String attendeePattern,
  ) {
    socialEvent.attendees = [];

    List<String> attendeesString =
        extractDataFromNotes(sourceText, attendeePattern);

    if (attendeesString.isEmpty) {
      return "So, it was a personal event? \nNot really social, is it? :D"
          "\n\nPlease add at least one attendee \n(type @name in the notes text box)";
    }

    List<Person> tempList = [];

    // Checking each entry
    for (var item in attendeesString) {
      item = item.replaceAll("_", " ");

      if (item.isEmpty) continue;

      // is .any() and .firstWhere() faster than this?
      bool found = false;

      for (var person in personsList) {
        if (person.name.toLowerCase() == item.toLowerCase()) {
          // FIXME: so ... what if two people have the same name? :D

          /// should be much more advanced and show possible options (if multiple)
          /// and user chooses between them
          /// but for now it can be enough

          tempList.add(person);
          found = true;
          break;
        }
      }

      if (!found) {
        return "Couldn't find '$item' in people"
            "\nPlease add them first.";
      }
    }

    socialEvent.attendees = tempList;

    return null;
  }
}
