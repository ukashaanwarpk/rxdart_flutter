import 'package:flutter/material.dart';
import 'package:rxdart_flutter/bloc/search_result.dart';
import 'package:rxdart_flutter/models/animal.dart';
import 'package:rxdart_flutter/models/person.dart';

class SearchViewResult extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchViewResult({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
      stream: searchResult,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;

          if (result is SearchResultHasError) {
            debugPrint('Got error ${result.error}');
            return Text('Got error ${result.error}');
          } else if (result is SearchResultLoading) {
            return Center(child: const CircularProgressIndicator());
          } else if (result is SearchResultNoResult) {
            return const Text(
              'No results found for your search term. Try with another one',
            );
          } else if (result is SearchResultWithResult) {
            final results = result.results;

            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];

                  final String title;

                  if (item is Animal) {
                    title = 'Animal';
                  } else if (item is Person) {
                    title = 'Person';
                  } else {
                    title = 'Unknown';
                  }

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString()),
                  );
                },
              ),
            );
          } else {
            return const Text('Unknown state');
          }
        } else {
          return Text('Waiting...');
        }
      },
    );
  }
}
