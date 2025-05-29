import 'package:flutter/material.dart';

@immutable
class Bloc {
  final Sink<String> firstName;
  final Sink<String> lastName;
  final Stream<String> fullName;

  const Bloc._({
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });
}

class CombineLastestStreamExample extends StatefulWidget {
  const CombineLastestStreamExample({super.key});

  @override
  State<CombineLastestStreamExample> createState() =>
      _CombineLastestStreamExampleState();
}

class _CombineLastestStreamExampleState
    extends State<CombineLastestStreamExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
