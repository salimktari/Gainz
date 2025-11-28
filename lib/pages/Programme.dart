import 'package:flutter/material.dart';

class Programme extends StatelessWidget {
  const Programme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programme d'entraînement")),
      body: const Center(child: Text("Page d'entraînement")),
    );
  }
}
