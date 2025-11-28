import 'package:flutter/material.dart';
import 'package:gainz/components/feature.dart';
import 'package:gainz/pages/Poids.dart';
import 'package:gainz/pages/Programme.dart';
import 'package:gainz/pages/Timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gainz',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/poids': (context) => const Poids(),
        '/programme': (context) => const Programme(),
        '/timer': (context) => const Timer(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("GAINZ"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //head
            const Text(
              "No pains No gains",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              "Ready for workout ?\n Let's start your fitness journey today!\n please make your choice .",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 24),

            //titre1
            const Text(
              "Fonctionnalités",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            //carte1
            FeatureWidget(
              title: "Programme d'entraînement",
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Programme()),
                );
              },
            ),

            const SizedBox(height: 12),

            //carte2
            FeatureWidget(
              title: "Timer d'exercices",
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Timer()),
                );
              },
            ),

            const SizedBox(height: 12),

            //carte3
            FeatureWidget(
              title: "Suivi du poids",
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Poids()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
