import 'package:flutter/material.dart';
import '../login_screen.dart';

void logout(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (Route<dynamic> route) => false,
  );
}

// Logout gumb za koristenje na vise ekrana
class LogoutButton extends StatelessWidget {
  final String buttonText;
  final ButtonStyle? style;

  const LogoutButton({
    Key? key,
    this.buttonText = 'Odjava',
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      style: style ?? IconButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        iconSize: 30,
      ),
      tooltip: 'Logout',
      onPressed: () => logout(context),
    );
  }
}