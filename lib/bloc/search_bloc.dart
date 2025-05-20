import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_flutter/bloc/api.dart';
import 'package:rxdart_flutter/bloc/search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search; // write
  final Stream<SearchResult?> results; // read

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();

    final Stream<SearchResult?> results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
          if (searchTerm.isEmpty) {
            return Stream<SearchResult?>.value(null);
          } else {
            return Rx.fromCallable(() => api.search(searchTerm))
                .delay((const Duration(seconds: 1)))
                .map(
                  (results) =>
                      results.isEmpty
                          ? SearchResultNoResult()
                          : SearchResultWithResult(results),
                )
                .startWith(
                  SearchResultLoading(),
                ) // startWith emits a value before the original stream
                .onErrorReturnWith((error, _) => SearchResultHasError(error));
          }
        });
    return SearchBloc._(search: textChanges.sink, results: results);
  }

  const SearchBloc._({required this.search, required this.results});
}
