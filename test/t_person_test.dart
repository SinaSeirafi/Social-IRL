import 'package:flutter_test/flutter_test.dart';
import 'package:social_irl/data/models/person_model.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/tag.dart';

void main() {
  test('Person to/from PersonModel Equatable test', () {
    Person test = Person(
      id: 1,
      name: "name",
      socialCircle: const SocialCircle(id: 1, title: "title"),
    );

    late Person returned;

    _checkEquality(bool expectVal) {
      expect(returned == test, expectVal);
    }

    _checkToAndFromPersonModel() {
      PersonModel model = PersonModel.personModelFromPerson(test);

      returned = model.personFromPersonModel();

      _checkEquality(true);
    }

    _checkToAndFromPersonModel();

    _checkEquality(true);

    test.lastSocialEvent = test.nextSocialEvent = DateTime.now();

    _checkEquality(false);

    returned.lastSocialEvent = returned.nextSocialEvent = test.nextSocialEvent;

    _checkEquality(true);

    _checkToAndFromPersonModel();

    test.tags.add(const PersonTag(id: 1, title: "title"));

    _checkEquality(false);

    _checkToAndFromPersonModel();

    test.isDeleted = true;

    _checkEquality(false);

    _checkToAndFromPersonModel();

    test.socialCircle = const SocialCircle(id: 2, title: "title");

    _checkEquality(false);

    _checkToAndFromPersonModel();

    test.potentialForCircle = const SocialCircle(id: 3, title: "title");

    _checkEquality(false);

    _checkToAndFromPersonModel();

    test.socialEvents.add(
      SocialEvent(id: 1, startDate: DateTime.now(), attendees: [test]),
    );

    _checkEquality(false);

    _checkToAndFromPersonModel();
  });
}
