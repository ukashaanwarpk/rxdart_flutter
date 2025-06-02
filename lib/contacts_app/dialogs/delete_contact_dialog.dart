import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/generic_dialog.dart';

Future<bool> showDeleteContactDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete contact',
    content:
        'Are you sure you want to delete this contact? you cannot undo this operation!',
    optionsBuilder: () => {'Cancel': false, 'Delete contact': true},
  ).then((value) => value ?? false);
}
