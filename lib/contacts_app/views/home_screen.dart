import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/blocs/app_bloc.dart';
import 'package:rxdart_flutter/contacts_app/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_flutter/contacts_app/blocs/views_bloc/current_view.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/auth_error_dialog.dart';
import 'package:rxdart_flutter/contacts_app/loading/loading_screen.dart';
import 'package:rxdart_flutter/contacts_app/views/new_contact_view.dart';
import 'contact_list_view.dart';
import 'login_view.dart';
import 'register_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppBloc appBloc;

  StreamSubscription<AuthError?>? _authErrorSub;
  StreamSubscription<bool>? _isLoadingSub;

  @override
  void initState() {
    super.initState();

    appBloc = AppBloc();
  }

  void handleAuthErrors(BuildContext context) async {
    await _authErrorSub?.cancel();
    _authErrorSub = appBloc.authError.listen((event) {
      final AuthError? authError = event;

      if (authError == null) {
        return;
      }
      if (context.mounted) {
        showAuthError(
          authError: authError,
          context: context,
        );
      }
    });
  }

  void setUpLoadingScreen() async {
    _isLoadingSub?.cancel();

    _isLoadingSub = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        if (mounted) {
          LoadingScreen.instance().show(
            context: context,
            text: 'Loading...',
          );
        } else {
          LoadingScreen.instance().hide();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    appBloc.dispose();

    _authErrorSub?.cancel();
    _isLoadingSub?.cancel();
  }

  Widget getHomePage() {
    return StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  login: appBloc.login,
                  goToRegisterView: appBloc.goToRegisterView,
                );
              case CurrentView.register:
                return RegisterView(
                  register: appBloc.register,
                  goToLoginView: appBloc.goToLoginView,
                );
              case CurrentView.contactList:
                return ContactListView(
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  deleteContact: appBloc.deleteContact,
                  createContact: appBloc.goToCreateContactView,
                  contacts: appBloc.contact,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContact: appBloc.createContact,
                  goBack: appBloc.goToContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setUpLoadingScreen();
    return getHomePage();
  }
}
