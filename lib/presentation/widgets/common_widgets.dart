import 'package:flutter/material.dart';

import '../../domain/entities/tag.dart';
import 'cn_widgets/cn_button.dart';
import 'cn_widgets/cn_message.dart';

class TagsInCardWrap extends StatelessWidget {
  const TagsInCardWrap({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<Tag>? tags;

  @override
  Widget build(BuildContext context) {
    if (tags == null || tags!.isEmpty) return Container();

    return Wrap(
      spacing: 8,
      children: [
        for (var tag in tags!)
          CnButton(
            elevation: 1,
            title: "#" + tag.title,
            largeTitle: false,
            onPressed: () {
              // TODO: Filter based on tag
              showCnMessage(
                context,
                text: "Later on, will filter this page based on tag",
              );
            },
          ),
      ],
    );
  }
}
