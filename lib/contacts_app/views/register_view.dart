import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_flutter/contacts_app/helpers/if_debugging.dart';
import 'package:rxdart_flutter/contacts_app/type_defination.dart';

class RegisterView extends HookWidget {
  final RegisterFunction register;
  final VoidCallback goToLoginView;

  const RegisterView({
    super.key,
    required this.register,
    required this.goToLoginView,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'ukasha0306@gmail.com'.ifDebugging,
    );

    final passwordController = useTextEditingController(
      text: '11111111'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here...',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here...',
              ),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '◉',
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                register(
                  email,
                  password,
                );
              },
              child: const Text(
                'Register',
              ),
            ),
            TextButton(
              onPressed: goToLoginView,
              child: const Text(
                'Already registered? Log in here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
