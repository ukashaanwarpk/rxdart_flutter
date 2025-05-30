import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

Stream<String> getNames({required String filePath}) {
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}

Stream<String> getAllNames() => getNames(
  filePath: 'assets/texts/cats.txt',
).concatWith([getNames(filePath: 'assets/texts/dogs.txt')]);

class ConcatStreamExampleScreen extends StatelessWidget {
  const ConcatStreamExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Concat Example'), centerTitle: true),

      body: FutureBuilder<List<String>>(
        future: getAllNames().toList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              final names = snapshot.requireData;

              return ListView.separated(
                itemCount: names.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(title: Text(names[index]));
                },
              );
          }
        },
      ),
    );
  }
}
