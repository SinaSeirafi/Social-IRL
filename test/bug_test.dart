import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

Set<A> allAs = {};
Set<B> allBs = {};

class A extends Equatable {
  final int id;
  late Set<int> bIdList;

  List<B> get bList {
    return allBs
        .where((element) => bIdList.contains(element.id))
        .toList()
        .cast<B>();
  }

  A(this.id) {
    bIdList = <int>{};

    allAs.add(this);
  }

  @override
  List<Object?> get props => [id, bIdList];
}

class B extends Equatable {
  final int id;
  List<A> aList;

  B(
    this.id,
    this.aList,
  ) {
    for (var a in aList) {
      a.bIdList.add(id);
    }

    allBs.add(this);
  }

  @override
  List<Object?> get props => [id, aList];
}

main() {
  test(
      'Test that showed me I need to change Person type and include SocialEventIds instead of objects',
      () {
    A a1 = A(1);
    A a2 = A(2);
    A a3 = A(3);
    A a4 = A(4);

    B b1 = B(1, [a1]);
    B b2 = B(2, [a2]);
    B b3 = B(3, [a3]);
    B b5 = B(5, [a3]);

    B b4 = B(4, [a1, a4]);
  });
}
