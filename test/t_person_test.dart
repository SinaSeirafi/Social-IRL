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

    // int count = 0;

    _checkEquality(bool expectVal) {
      expect(returned == test, expectVal);
      // if (!expectVal) print(++count);
    }

    _checkToAndFromPersonModel() {
      PersonModel model = PersonModel.fromPerson(test);

      var json = model.toJson();
      model = PersonModel.fromJson(json);

      returned = model.toPerson();

      _checkEquality(true);
    }

    _checkToAndFromPersonModel();

    var now = DateTime.now();
    test.lastSocialEvent = now;
    _checkEquality(false);
    returned.lastSocialEvent = now;
    _checkEquality(true);
    test.nextSocialEvent = now;
    _checkEquality(false);
    returned.nextSocialEvent = now;
    _checkEquality(true);

    PersonTag tag = const PersonTag(id: 1, title: "title");
    test.tags.add(tag);
    _checkEquality(false);
    returned.tags.add(tag);
    _checkEquality(true);

    _checkToAndFromPersonModel();

    test.isDeleted = true;
    _checkEquality(false);
    test.isDeleted = false;
    _checkEquality(true);

    _checkToAndFromPersonModel();

    SocialCircle socialCircle2 = const SocialCircle(id: 2, title: "title");
    test.socialCircle = socialCircle2;
    _checkEquality(false);
    returned.socialCircle = socialCircle2;
    _checkEquality(true);

    _checkToAndFromPersonModel();

    SocialCircle potentialCircle = const SocialCircle(id: 3, title: "title");
    test.potentialForCircle = potentialCircle;
    _checkEquality(false);
    returned.potentialForCircle = potentialCircle;
    _checkEquality(true);

    _checkToAndFromPersonModel();

    SocialEvent event =
        SocialEvent(id: 1, startDate: DateTime.now(), attendees: [test]);
    test.socialEvents.add(event);
    _checkEquality(false);
    returned.socialEvents.add(event);
    _checkEquality(true);

    _checkToAndFromPersonModel();

    String note = "testing note";
    test.notes = note;
    _checkEquality(false);
    returned.notes = note;
    _checkEquality(true);

    _checkToAndFromPersonModel();

    String newName = "testing name";
    test.name = newName;
    _checkEquality(false);
    returned.name = newName;
    _checkEquality(true);

    _checkToAndFromPersonModel();

    test.createdAt = test.modifiedAt = now;
    _checkEquality(false);
    returned.createdAt = returned.modifiedAt = now;
    _checkEquality(true);
  });
}
