import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_flutter/contacts_app/helpers/if_debugging.dart';
import 'package:rxdart_flutter/contacts_app/type_defination.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;
  const NewContactView({
    super.key,

    required this.createContact,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(
      text: 'Ukasha'.ifDebugging,
    );
    final lastNameController = useTextEditingController(
      text: 'Anwar'.ifDebugging,
    );
    final phoneNumberController = useTextEditingController(
      text: '03068265548'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: Icon(
            Icons.close,
          ),
        ),

        title: const Text('Create a new contact'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(hintText: 'First name...'),
              ),
              TextField(
                controller: lastNameController,
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(hintText: 'Last name...'),
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(hintText: 'Phone number...'),
              ),
              TextButton(
                onPressed: () {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phoneNumber = phoneNumberController.text;
                  createContact(firstName, lastName, phoneNumber);
                  goBack();
                },
                child: Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
