import 'package:flutter/material.dart';
import 'package:rxdart_flutter/combine_lastest_stream_example.dart';
import 'package:rxdart_flutter/filter_chip_screen.dart';
import 'package:rxdart_flutter/switch_map_stream_example.dart';

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
      home: CombineLastestStreamExample(),
    );
  }
}
