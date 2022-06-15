import 'package:flutter_test/flutter_test.dart';
import 'package:social_irl/data/models/person_model.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/tag.dart';

void main() {
  test('Person Model Incomplete Json save and retrieval Equatable test', () {
    PersonModel test = PersonModel(
      id: 1,
      name: "name",
      socialCircle: const SocialCircle(id: 1, title: "title"),
    );

    late PersonModel returned;

    _checkEquality(bool expectVal) {
      expect(returned == test, expectVal);
    }

    _checkToAndFromJson() {
      var json = test.toJsonIncomplete();

      returned = PersonModel.fromJsonIncomplete(json);

      _checkEquality(true);
    }

    _checkToAndFromJson();

    _checkEquality(true);

    test.lastSocialEvent = test.nextSocialEvent = DateTime.now();

    _checkEquality(false);

    returned.lastSocialEvent = returned.nextSocialEvent = test.nextSocialEvent;

    _checkEquality(true);

    _checkToAndFromJson();

    test.tags.add(const PersonTag(id: 1, title: "title"));

    _checkEquality(false);

    _checkToAndFromJson();

    test.isDeleted = true;

    _checkEquality(false);
  });
}
