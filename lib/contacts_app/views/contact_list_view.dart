import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/delete_contact_dialog.dart';
import 'package:rxdart_flutter/contacts_app/models/contact_model.dart';
import 'package:rxdart_flutter/contacts_app/type_defination.dart';

class ContactListView extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;
  const ContactListView({
    super.key,
    required this.contact,
    required this.deleteContact,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        onPressed: () async {
          final shouldDelete = await showDeleteContactDialog(context);
          if (shouldDelete) {
            deleteContact(contact);
          }
        },
        icon: Icon(
          Icons.delete,
        ),
      ),
    );
  }
}
