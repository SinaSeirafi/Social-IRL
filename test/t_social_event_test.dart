import 'package:flutter_test/flutter_test.dart';

import 'package:social_irl/data/models/social_event_model.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/tag.dart';

void main() {
  test('SocialEvent to/from SocialEventModel Equatable test', () {
    SocialEvent test = SocialEvent(
      id: 1,
      startDate: DateTime.now(),
      // ignore: prefer_const_literals_to_create_immutables
      attendees: [],
    );

    late SocialEvent returned;

    // int count = 0;

    _checkEquality(bool expectVal) {
      expect(returned == test, expectVal);
      // if (!expectVal) print(++count);
    }

    _checkToAndFromSocialEventModel() {
      SocialEventModel model = SocialEventModel.fromSocialEvent(test);

      var json = model.toJson();
      model = SocialEventModel.fromJson(json);

      returned = model.toSocialEvent();

      _checkEquality(true);
    }

    _checkToAndFromSocialEventModel();

    var now = DateTime.now();
    test.startDate = now;
    _checkEquality(false);
    returned.startDate = now;
    _checkEquality(true);
    test.endDate = now;
    _checkEquality(false);
    returned.endDate = now;
    _checkEquality(true);

    SocialEventTag tag = const SocialEventTag(id: 1, title: "title");
    test.tags.add(tag);
    _checkEquality(false);
    returned.tags.add(tag);
    _checkEquality(true);

    _checkToAndFromSocialEventModel();

    test.isDeleted = true;
    _checkEquality(false);
    test.isDeleted = false;
    _checkEquality(true);

    _checkToAndFromSocialEventModel();

    SocialCircle socialCircle = const SocialCircle(id: 2, title: "title");
    Person person = Person(id: 1, name: "name", socialCircle: socialCircle);
    test.attendees.add(person);
    _checkEquality(false);
    returned.attendees.add(person);
    _checkEquality(true);

    _checkToAndFromSocialEventModel();

    String note = "testing note";
    test.notes = note;
    _checkEquality(false);
    returned.notes = note;
    _checkEquality(true);

    _checkToAndFromSocialEventModel();

    String newName = "testing name";
    test.title = newName;
    _checkEquality(false);
    returned.title = newName;
    _checkEquality(true);

    _checkToAndFromSocialEventModel();

    test.createdAt = test.modifiedAt = now;
    _checkEquality(false);
    returned.createdAt = returned.modifiedAt = now;
    _checkEquality(true);
  });
}
