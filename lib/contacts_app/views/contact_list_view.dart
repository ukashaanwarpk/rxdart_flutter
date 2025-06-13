import 'package:flutter/material.dart';
import 'package:rxdart_flutter/contacts_app/dialogs/delete_contact_dialog.dart';
import 'package:rxdart_flutter/contacts_app/models/contact_model.dart';
import 'package:rxdart_flutter/contacts_app/type_defination.dart';
import 'main_popup_menu_button.dart';

class ContactListView extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;
  final DeleteContactCallback deleteContact;
  final VoidCallback createContact;
  final Stream<Iterable<Contact>> contacts;
  const ContactListView({
    super.key,
    required this.logout,
    required this.deleteAccount,
    required this.deleteContact,
    required this.createContact,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts List'),
        centerTitle: true,
        actions: [
          MainPopupMenuButton(
            logout: logout,
            deleteAccount: deleteAccount,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createContact,
        child: Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              final contacts = snapshot.requireData;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final contact = contacts.elementAt(index);
                  return ContactListTile(
                    contact: contact,
                    deleteContact: deleteContact,
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;
  const ContactListTile({
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
