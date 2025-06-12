import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_flutter/contacts_app/blocs/views_bloc/current_view.dart';

@immutable
class ViewsBloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  void dispose() {
    goToView.close();
  }

  const ViewsBloc._({
    required this.goToView,
    required this.currentView,
  });

  factory ViewsBloc() {
    final goToViewSubject = BehaviorSubject<CurrentView>();

    return ViewsBloc._(
      goToView: goToViewSubject,
      currentView: goToViewSubject.startWith(CurrentView.login),
    );
  }
}
