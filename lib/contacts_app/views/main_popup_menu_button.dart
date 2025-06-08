import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/logout_dialog.dart';
import 'package:rxdart_flutter/contacts_app/type_defination.dart';
import '../dialogs/delete_account_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;
  const MainPopupMenuButton({
    super.key,
    required this.logout,
    required this.deleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if (shouldLogout) {
              return logout();
            }
            break;

          case MenuAction.deleteAccount:
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              return deleteAccount();
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
