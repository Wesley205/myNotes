import 'package:flutter/material.dart';
import 'package:nova/constants/routes1.dart';
import 'package:nova/services/auth/auth_service.dart';
import 'package:nova/views/login_view.dart';
import 'package:nova/views/notes/notes_view.dart';

void main() async {
  WidgetsFlutterBinding();

  await AuthService.firebase().initialize();

  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      home: AuthService.firebase().currentUser == null
          ? const LoginView()
          : const NotesView(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
