import 'package:flutter/material.dart';
import 'package:rxdart_flutter/behaviour_subject_example.dart';
import 'package:rxdart_flutter/combine_stream_example.dart';
import 'package:rxdart_flutter/concat_stream_example.dart';
import 'package:rxdart_flutter/merge_stream_example.dart';
import 'package:rxdart_flutter/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MergeStreamExample(),
    );
  }
}
