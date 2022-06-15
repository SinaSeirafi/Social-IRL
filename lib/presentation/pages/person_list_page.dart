import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/presentation/widgets/person_card.dart';

import '../bloc/person_bloc.dart';
import '../widgets/cn_widgets/cn_animations.dart';

class PeopleListPage extends StatefulWidget {
  const PeopleListPage({Key? key}) : super(key: key);

  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonLoaded) {
            if (state.persons.isEmpty) {
              return const Center(
                child: Text("Add people with the button below"),
              );
            }

            return ListView(
              children: [
                for (var person in state.persons) PersonCard(person: person),
              ],
            );
          }

          return const Center(
            child: CnDottedLoadingAnimation(),
          );
        },
      ),
    );
  }
}
