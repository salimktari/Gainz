import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                onSaved: (value) => email = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  if (!value.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
                onSaved: (value) => password = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        )
                        .then((value) {
                          Navigator.pushReplacementNamed(context, '/');
                        })
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login failed: $error')),
                          );
                        });
                  }
                },
                child: const Text('Login'),
              ),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
