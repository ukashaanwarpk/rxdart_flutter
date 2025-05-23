import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SwitchMapStreamExample extends StatefulWidget {
  const SwitchMapStreamExample({super.key});

  @override
  State<SwitchMapStreamExample> createState() => _SwitchMapStreamExampleState();
}

class _SwitchMapStreamExampleState extends State<SwitchMapStreamExample> {
  late final BehaviorSubject<DateTime> _subject;

  late final Stream<String> _streamOfString;

  @override
  void initState() {
    super.initState();

    _subject = BehaviorSubject<DateTime>();
    _streamOfString = _subject.switchMap(
      (dateTime) => Stream.periodic(
        const Duration(seconds: 1),
        (count) => 'Stream count =$count, dateTime =$dateTime',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwitchMap'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StreamBuilder<String>(
              stream: _streamOfString,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final string = snapshot.requireData;
                  return Text(string);
                } else {
                  return Text('Waiting for the button to be pressed ');
                }
              },
            ),

            TextButton(
              onPressed: () {
                _subject.add(DateTime.now());
              },
              child: Text('Start the stream'),
            ),
          ],
        ),
      ),
    );
  }
}
