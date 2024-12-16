import 'package:flutter/material.dart';
import 'package:nova/constants/routes1.dart';
import 'package:nova/services/auth/auth_exceptions.dart';
import 'package:nova/services/auth/auth_service.dart';
import 'package:nova/utilies/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(
                      Routes.verifyEmailRoute,
                      
                    );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    "Weak password",
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    "Email is already in use",
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    "invalid-email",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Failed to register',
                  );
                }
              },
              child: const Text("Register")),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.loginRoute,
                      (route) => false,
                    );
            },
            child: const Text('Already have an account? Sign in'),
          )
        ],
      ),
    );
  }
}