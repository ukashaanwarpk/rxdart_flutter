import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart_flutter/models/animal.dart';
import 'package:rxdart_flutter/models/person.dart';
import 'package:rxdart_flutter/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Person>? _persons;
  List<Animal>? _animals;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    try {
      final term = searchTerm.trim().toLowerCase();

      // search in the cache

      final cachedResults = _extractThingsUsingSearchTerm(term);

      if (cachedResults != null) {
        return cachedResults;
      }

      // so we don't have the values cached, let's call api

      final persons = await _getJson(
        'http://192.168.100.3:5500/apis/persons.json',
      ).then((json) => json.map((value) => Person.fromJson(value)));

      _persons = persons.toList();

      final animals = await _getJson(
        'http://192.168.100.3:5500/apis/animals.json',
      ).then((json) => json.map((value) => Animal.fromJson(value)));

      _animals = animals.toList();

      return _extractThingsUsingSearchTerm(term) ?? [];
    } catch (e, stackTrace) {
      debugPrint('The error is $e, $stackTrace');
      rethrow;
    }
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedPersons != null && cachedAnimals != null) {
      List<Thing> result = [];

      // go through animals

      for (var animal in cachedAnimals) {
        if (animal.name.trimmedContain(term) ||
            animal.type.name.trimmedContain(term)) {
          result.add(animal);
        }
      }

      // go through persons

      for (var person in cachedPersons) {
        if (person.name.trimmedContain(term) ||
            person.age.toString().trimmedContain(term)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContain(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
