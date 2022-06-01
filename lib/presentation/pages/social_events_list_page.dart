import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_animations.dart';
import 'package:social_irl/presentation/widgets/social_event_card.dart';

import '../bloc/social_event_bloc.dart';

class SocialEventsListPage extends StatefulWidget {
  const SocialEventsListPage({Key? key}) : super(key: key);

  @override
  State<SocialEventsListPage> createState() => _SocialEventsListPageState();
}

class _SocialEventsListPageState extends State<SocialEventsListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialEventBloc, SocialEventState>(
      builder: (context, state) {
        if (state is SocialEventLoaded) {
          if (state.events.isEmpty) {
            return const Center(
              child: Text("Add events with the button below"),
            );
          }

          return ListView(
            children: [
              for (var socialEvent in state.events)
                SocialEventCard(socialEvent: socialEvent)
            ],
          );
        }

        return const Center(
          child: CnDottedLoadingAnimation(),
        );
      },
    );
  }
}
