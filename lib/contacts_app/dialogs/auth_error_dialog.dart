import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: authError.dialogText,
    content: authError.dialogText,
    optionsBuilder:
        () => {
          'OK': true,
        },
  );
}
