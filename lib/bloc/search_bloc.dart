import 'package:rxdart/rxdart.dart';
import 'package:rxdart_flutter/bloc/api.dart';
import 'package:rxdart_flutter/bloc/search_result.dart';

class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

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
                .startWith(SearchResultLoading())
                .onErrorReturnWith((error, _) => SearchResultHasError(error));
          }
        });
    return SearchBloc._(search: textChanges.sink, results: results);
  }

  SearchBloc._({required this.search, required this.results});
}
