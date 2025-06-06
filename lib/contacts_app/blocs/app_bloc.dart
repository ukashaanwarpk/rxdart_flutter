import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_flutter/contacts_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:rxdart_flutter/contacts_app/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_flutter/contacts_app/blocs/contacts_bloc.dart';
import 'package:rxdart_flutter/contacts_app/blocs/views_bloc/current_view.dart';
import 'package:rxdart_flutter/contacts_app/blocs/views_bloc/views_bloc.dart';

import '../models/contact_model.dart';

@immutable
class AppBloc {
  final AuthBloc _authBloc;
  final ViewsBloc _viewsBloc;
  final ContactsBloc _contactsBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewsBloc viewsBloc,
    required ContactsBloc contactsBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  }) : _authBloc = authBloc,
       _viewsBloc = viewsBloc,
       _contactsBloc = contactsBloc,
       _userIdChanges = userIdChanges;

  void dispose() {
    _authBloc.dispose();
    _viewsBloc.dispose();
    _contactsBloc.dispose();
    _userIdChanges.cancel();
  }

  factory AppBloc() {
    final authBloc = AuthBloc();
    final viewBloc = ViewsBloc();
    final contactsBloc = ContactsBloc();

    // pass userId from auth bloc into the contacts bloc

    final userIdChanges = authBloc.userId.listen((String? userId) {
      contactsBloc.userId.add(userId);
    });

    // calculate current view

    final Stream<CurrentView> currentViewBasedOnAuthStatus = authBloc.authStatus
        .map((authStatus) {
          if (authStatus is AuthStatusLoggedIn) {
            return CurrentView.contactList;
          } else {
            return CurrentView.login;
          }
        });

    // current view
    final Stream<CurrentView> currentView = Rx.merge([
      currentViewBasedOnAuthStatus,
      viewBloc.currentView,
    ]);

    final Stream<bool> isLoading = Rx.merge([authBloc.isLoading]);

    return AppBloc._(
      authBloc: authBloc,
      viewsBloc: viewBloc,
      contactsBloc: contactsBloc,
      currentView: currentView,
      isLoading: isLoading.asBroadcastStream(),
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

  // delete Contact

  void deleteContact(Contact contact) {
    _contactsBloc.deleteContact.add(contact);
  }

  // create Contact

  void createContact(String firstName, String lastName, String phoneNumber) {
    _contactsBloc.createContact.add(
      Contact.withoutId(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  // logout

  void logout() {
    _authBloc.logout.add(null);
  }

  Stream<Iterable<Contact>> get contact => _contactsBloc.contacts;

  void register(String email, String password) {
    _authBloc.register.add(RegisterCommand(email: email, password: password));
  }

  void login(String email, String password) {
    _authBloc.login.add(LoginCommand(email: email, password: password));
  }

  void goToContactListView() =>
      _viewsBloc.goToView.add(CurrentView.contactList);

  void goToContactCreateContactView() =>
      _viewsBloc.goToView.add(CurrentView.createContact);

  void goToRegisterView() => _viewsBloc.goToView.add(CurrentView.register);

  void goToLoginView() => _viewsBloc.goToView.add(CurrentView.login);
}
