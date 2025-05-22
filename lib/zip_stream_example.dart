import 'dart:developer' as devtools show log;

import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';

class ZipStreamExample extends StatelessWidget {
  const ZipStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zip stream'), centerTitle: true),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (count) => 'Stream 1 , count = $count',
  );
  final stream2 = Stream.periodic(
    const Duration(seconds: 5),
    (count) => 'Stream 2 , count = $count',
  );

  final result = Rx.zip2(
    stream1,
    stream2,
    (one, two) => 'One = ($one), Two = ($two)',
  );

  await for (final value in result) {
    value.log();
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
