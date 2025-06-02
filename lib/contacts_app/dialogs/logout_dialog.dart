import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {'Cancel': false, 'Log out': true},
  ).then((value) => value ?? false);
}
