import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class Bloc {
  final Sink<String?> setFirstName;
  final Sink<String?> setLastName;
  final Stream<String> fullName;

  void dispose() {
    setFirstName.close();
    setLastName.close();
  }

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  factory Bloc() {
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();

    final Stream<String> fullName = Rx.combineLatest2(
      firstNameSubject.startWith(null),
      lastNameSubject.startWith(null),
      (String? firstName, String? lastName) {
        if (firstName != null &&
            firstName.isNotEmpty &&
            lastName != null &&
            lastName.isNotEmpty) {
          return '$firstName $lastName';
        } else {
          return 'Both first and last name must be provided';
        }
      },
    );

    return Bloc._(
      setFirstName: firstNameSubject.sink,
      setLastName: lastNameSubject.sink,
      fullName: fullName,
    );
  }
}

typedef AsyncSnapshotBuilderCallback<T> =
    Widget Function(BuildContext context, T? value);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;

  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;

  final AsyncSnapshotBuilderCallback<T>? onActive;

  final AsyncSnapshotBuilderCallback<T>? onDone;

  const AsyncSnapshotBuilder({
    super.key,
    required this.stream,
    this.onNone,
    this.onWaiting,
    this.onActive,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            final callBack = onNone ?? (_, __) => SizedBox();

            return callBack(context, snapshot.data);

          case ConnectionState.waiting:
            final callBack =
                onWaiting ?? (_, __) => CircularProgressIndicator();

            return callBack(context, snapshot.data);
          case ConnectionState.active:
            final callBack = onActive ?? (_, __) => SizedBox();

            return callBack(context, snapshot.data);

          case ConnectionState.done:
            final callBack = onActive ?? (_, __) => SizedBox();

            return callBack(context, snapshot.data);
        }
      },
    );
  }
}

class CombineLastestStreamExample extends StatefulWidget {
  const CombineLastestStreamExample({super.key});

  @override
  State<CombineLastestStreamExample> createState() =>
      _CombineLastestStreamExampleState();
}

class _CombineLastestStreamExampleState
    extends State<CombineLastestStreamExample> {
  late final Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Bloc();
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combine Stream with RxDart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter first name here ...',
              ),
              onChanged: _bloc.setFirstName.add,
            ),

            TextField(
              decoration: InputDecoration(hintText: 'Enter last name here ...'),
              onChanged: _bloc.setLastName.add,
            ),

            AsyncSnapshotBuilder<String>(
              stream: _bloc.fullName,
              onActive: (context, String? value) {
                return Text(value ?? '');
              },
            ),
          ],
        ),
      ),
    );
  }
}
