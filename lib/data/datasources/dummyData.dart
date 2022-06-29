import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/tag.dart';
import 'package:social_irl/domain/usecases/social_event_usecases.dart';

import '../../domain/usecases/person_usecases.dart';

Future generateDummyData() async {
  AddPerson _addPerson = AddPerson();

  await _addPerson(PersonParams(dummyPerson1));
  await _addPerson(PersonParams(dummyPerson2));
  await _addPerson(PersonParams(dummyPerson3));
  await _addPerson(PersonParams(dummyPerson4));

  AddSocialEventUsecase _addEvent = AddSocialEventUsecase();

  await _addEvent(SocialEventParams(dummySocialEvent1));
  await _addEvent(SocialEventParams(dummySocialEvent2));
  await _addEvent(SocialEventParams(dummySocialEvent3));
  // await _addEvent(SocialEventParams(dummySocialEvent4));
}

Person dummyPerson1 = Person(
  id: 1,
  name: "Nas",
  socialCircle: dummySocialCircle1,
);

Person dummyPerson2 = Person(
  id: 2,
  name: "Shyn",
  socialCircle: dummySocialCircle1,
);

Person dummyPerson3 = Person(
  id: 3,
  name: "Ava",
  socialCircle: dummySocialCircle1,
);

Person dummyPerson4 = Person(
  id: 4,
  name: "Alaleh",
  socialCircle: dummySocialCircle2,
);

List<SocialCircle> allSocialCircles = const [
  dummySocialCircle0,
  dummySocialCircle1,
  dummySocialCircle2,
  dummySocialCircle3,
  dummySocialCircle4,
];

const SocialCircle dummySocialCircle0 = SocialCircle(id: 0, title: "❤️");
const SocialCircle dummySocialCircle1 = SocialCircle(id: 1, title: "😍");
const SocialCircle dummySocialCircle2 = SocialCircle(id: 2, title: "🥰");
const SocialCircle dummySocialCircle3 = SocialCircle(id: 3, title: "🤗");
const SocialCircle dummySocialCircle4 = SocialCircle(id: 4, title: "😊");

PersonTag dummyPersonTag1 = const PersonTag(id: 1, title: "Uni");
PersonTag dummyPersonTag2 = const PersonTag(id: 2, title: "Jung Class");
PersonTag dummyPersonTag3 = const PersonTag(id: 3, title: "Another Friend");

SocialEvent dummySocialEvent1 = SocialEvent(
  id: 1,
  startDate: DateTime.now(),
  attendees: [dummyPerson1],
);

SocialEvent dummySocialEvent2 = SocialEvent(
  id: 2,
  startDate: DateTime.now(),
  attendees: [dummyPerson2],
);

SocialEvent dummySocialEvent3 = SocialEvent(
  id: 3,
  startDate: DateTime.now(),
  attendees: [dummyPerson3],
);

SocialEvent dummySocialEvent4 = SocialEvent(
  id: 4,
  startDate: DateTime.now(),
  attendees: [
    dummyPerson1,
    dummyPerson2,
    dummyPerson3,
    dummyPerson4,
  ],
);
