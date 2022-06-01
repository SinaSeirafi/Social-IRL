import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/entities/tag.dart';

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
  id: 3,
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
  id: 1,
  startDate: DateTime.now(),
  attendees: [dummyPerson1, dummyPerson2],
);
