import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

class ConcatStreamExample extends StatelessWidget {
  const ConcatStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(title: Text('Concat stream'), centerTitle: true),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (count) => 'Stream 1 , count = $count',
  ).take(3);
  final stream2 = Stream.periodic(
    const Duration(seconds: 1),
    (count) => 'Stream 2 , count = $count',
  );

  final result = stream1.concatWith([stream2]);

  await for (final value in result) {
    value.log();
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
