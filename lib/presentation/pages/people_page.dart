import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/presentation/widgets/person_card.dart';

import '../bloc/person_bloc.dart';

class PeopleListPage extends StatefulWidget {
  const PeopleListPage({Key? key}) : super(key: key);

  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        if (state is PersonLoaded) {
          return ListView(
            children: [
              for (var person in state.persons) PersonCard(person: person),
            ],
          );
        }

        return Center(
          child: Text("People!!"),
        );
      },
    );
  }
}
