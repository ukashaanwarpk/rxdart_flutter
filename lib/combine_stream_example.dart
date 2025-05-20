import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

class CombineStreamExample extends StatelessWidget {
  const CombineStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Combine stream'), centerTitle: true),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
    Duration(seconds: 1),
    (count) => 'Stream 1 , count = $count',
  );

  final stream2 = Stream.periodic(
    Duration(seconds: 3),
    (count) => 'Stream 2 , count = $count',
  );

  final combined = Rx.combineLatest2(
    stream1,
    stream2,
    (one, two) => 'One = ($one), Two = ($two)',
  );

  await for (final value in combined) {
    value.log();
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
