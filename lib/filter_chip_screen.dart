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
  late final Bloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = Bloc(things: things);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Chip with RxDart'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: bloc.currentTypeOfThings,

              builder: (context, snapshot) {
                final selectedTypeOfThing = snapshot.data;
                return Wrap(
                  spacing: 12,
                  children:
                      TypeOFThings.values.map((typeOfThing) {
                        return FilterChip(
                          selected: selectedTypeOfThing == typeOfThing,
                          selectedColor: Colors.blue[100],
                          label: Text(typeOfThing.name),
                          onSelected: (selected) {
                            final type = selected ? typeOfThing : null;
                            bloc.setTypeOfThings.add(type);
                          },
                        );
                      }).toList(),
                );
              },
            ),

            Expanded(
              child: StreamBuilder<Iterable<Things>>(
                stream: bloc.things,
                builder: (context, snapshot) {
                  final things = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: things.length,
                    itemBuilder: (context, index) {
                      final thing = things.elementAt(index);
                      return ListTile(
                        title: Text(thing.name),
                        subtitle: Text(thing.type.name),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
