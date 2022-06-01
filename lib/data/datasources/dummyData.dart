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

SocialCircle dummySocialCircle1 = const SocialCircle(id: 1, title: "1");
SocialCircle dummySocialCircle2 = const SocialCircle(id: 2, title: "2");
SocialCircle dummySocialCircle3 = const SocialCircle(id: 3, title: "3");
SocialCircle dummySocialCircle4 = const SocialCircle(id: 4, title: "4");

PersonTag dummyPersonTag1 = const PersonTag(id: 1, title: "Uni");
PersonTag dummyPersonTag2 = const PersonTag(id: 2, title: "Jung Class");
PersonTag dummyPersonTag3 = const PersonTag(id: 3, title: "Another Friend");

SocialEvent dummySocialEvent1 = SocialEvent(
  id: 1,
  startDate: DateTime.now(),
  attendees: [dummyPerson1],
);
