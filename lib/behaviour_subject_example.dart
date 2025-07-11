import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

class BehaviourSubjectExample extends StatefulWidget {
  const BehaviourSubjectExample({super.key});

  @override
  State<BehaviourSubjectExample> createState() =>
      _BehaviourSubjectExampleState();
}

class _BehaviourSubjectExampleState extends State<BehaviourSubjectExample> {
  late final BehaviorSubject<String> _subject;

  @override
  void initState() {
    super.initState();
    _subject = BehaviorSubject<String>();
  }

  @override
  void dispose() async {
    await _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: StreamBuilder<String>(
          stream: _subject.stream.distinct().debounceTime(Duration(seconds: 1)),
          initialData: 'Start typing here',
          builder: (context, snapshot) {
            return Text(snapshot.requireData);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: TextField(onChanged: _subject.sink.add),
      ),
    );
  }
}
