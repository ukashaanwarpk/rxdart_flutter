import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:rxdart/rxdart.dart';

class MergeStreamExample extends StatelessWidget {
  const MergeStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Merge stream'), centerTitle: true),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (count) => 'Stream 1 , count = $count',
  );
  final stream2 = Stream.periodic(
    const Duration(seconds: 3),
    (count) => 'Stream 2 , count = $count',
  );

  final result = stream1.mergeWith([stream2]);

  await for (final value in result) {
    value.log();
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
