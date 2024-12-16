import 'package:flutter/material.dart';
import 'package:nova/views/login_view.dart';
import 'package:nova/views/notes/new_note_view.dart';
import 'package:nova/views/notes/notes_view.dart';
import 'package:nova/views/register_view.dart';
import 'package:nova/views/verifyemail_view.dart';

class Routes {
  //static const String logRoute = '/';
  static const String loginRoute = '/login/';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String verifyEmailRoute = '/verify-email';
  static const String notesRoute = '/notes';
  static const String newNoteRoute = '/new-note';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case verifyEmailRoute:
        return MaterialPageRoute(builder: (_) => const VerifyEmailView());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case notesRoute:
        return MaterialPageRoute(builder: (_) => const NotesView());
      case newNoteRoute:
        return MaterialPageRoute(builder: (_) => const NewNotesView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Text("Route not found! ${settings.name}"),
            ),
          ),
        );
    }
  }
}
