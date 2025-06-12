import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure you want to delete your account? you cannot undo this operation!',
    optionsBuilder:
        () => {
          'Cancel': false,
          'Delete account': true,
        },
  ).then(
    (value) => value ?? false,
  );
}
