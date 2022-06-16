import 'package:flutter_test/flutter_test.dart';

import 'package:social_irl/data/models/social_event_model.dart';
import 'package:social_irl/domain/entities/tag.dart';

void main() {
  test('SocialEventModel to and from Json Equatable test', () {
    SocialEventModel test = SocialEventModel(
      id: 1,
      startDate: DateTime.now(),
      // ignore: prefer_const_literals_to_create_immutables
      attendeesIds: [],
    );

    late SocialEventModel returned;

    _checkEquality(bool expectVal) {
      expect(returned == test, expectVal);
    }

    _checkToAndFromJson() {
      var json = test.toJson();

      returned = SocialEventModel.fromJson(json);

      _checkEquality(true);
    }

    _checkToAndFromJson();

    _checkEquality(true);

    test.startDate = test.endDate = DateTime.now();

    _checkEquality(false);

    returned.startDate = returned.endDate = test.startDate;

    _checkEquality(true);

    _checkToAndFromJson();

    test.tags.add(const SocialEventTag(id: 1, title: "title"));

    _checkEquality(false);

    _checkToAndFromJson();

    test.isDeleted = true;

    _checkEquality(false);

    _checkToAndFromJson();

    test.title = "title";

    _checkEquality(false);

    _checkToAndFromJson();

    test.attendeesIds.add(1);

    _checkEquality(false);

    _checkToAndFromJson();
  });
}
