import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypeOFThings { animal, person }

@immutable
class Things {
  final String name;
  final TypeOFThings type;

  const Things({required this.name, required this.type});
}

@immutable
class Bloc {
  final Sink<TypeOFThings?> setTypeOfThings;
  final Stream<TypeOFThings?> currentTypeOfThings;
  final Stream<Iterable<Things>> things;

  void dispose() {
    setTypeOfThings.close();
  }

  const Bloc._({
    required this.setTypeOfThings,
    required this.currentTypeOfThings,
    required this.things,
  });

  factory Bloc({required Iterable<Things> things}) {
    final typeOFThingsSubject = BehaviorSubject<TypeOFThings?>();

    final filteredThings = typeOFThingsSubject
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<Things>>((typeOfThing) {
          if (typeOfThing != null) {
            return things.where((thing) => thing.type == typeOfThing);
          } else {
            return things;
          }
        })
        .startWith(things);

    return Bloc._(
      setTypeOfThings: typeOFThingsSubject.sink,
      currentTypeOfThings: typeOFThingsSubject.stream,
      things: filteredThings,
    );
  }
}

const things = [
  Things(name: 'Dog', type: TypeOFThings.animal),
  Things(name: 'Cat', type: TypeOFThings.animal),
  Things(name: 'Rabbit', type: TypeOFThings.animal),

  Things(name: 'John', type: TypeOFThings.person),
  Things(name: 'Jane', type: TypeOFThings.person),
  Things(name: 'Doe', type: TypeOFThings.person),
];

class FilterChipScreen extends StatefulWidget {
  const FilterChipScreen({super.key});

  @override
  State<FilterChipScreen> createState() => _FilterChipScreenState();
}

class _FilterChipScreenState extends State<FilterChipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Chip with RxDart'),
        centerTitle: true,
      ),
    );
  }
}
