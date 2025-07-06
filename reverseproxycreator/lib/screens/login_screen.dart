import 'package:flutter/material.dart';
import 'package:reverseproxycreator/screens/admin_screen.dart';
import 'package:reverseproxycreator/screens/data_send_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    if (username == 'admin' && password == 'admin') {
      // Nav na admin
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else if (username == 'user' && password == 'user') {
      // Nav na user
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DataSendPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kriva lozinka ili korisničko ime.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Korisničko ime',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Lozinka',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}