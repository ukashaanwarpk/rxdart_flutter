import 'package:flutter/material.dart';
import 'package:rxdart_flutter/search_api/bloc/api.dart';
import 'package:rxdart_flutter/search_api/bloc/search_bloc.dart';
import 'package:rxdart_flutter/search_api/views/search_view_result.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(api: Api());
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: _searchBloc.search.add,
              decoration: InputDecoration(
                hintText: 'Enter your search term here',
              ),
            ),
            const SizedBox(height: 10),
            SearchViewResult(searchResult: _searchBloc.results),
          ],
        ),
      ),
    );
  }
}
