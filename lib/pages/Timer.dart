import 'package:flutter/material.dart';

class Timer extends StatelessWidget {
  const Timer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ready ? Set Go !")),
      body: const Center(child: Text("3 2 1 Go !")),
    );
  }
}
