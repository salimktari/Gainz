import 'dart:async';

import 'package:flutter/material.dart';

// Page de compte à rebours pour les exercices
class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  int dureeInitialeEnSecondes = 60;
  int secondesRestantes = 60;
  bool enCours = false;
  bool enPause = false;
  Timer? timerInstance;

  // Formatte les secondes restantes en MM:SS
  String formaterSecondes(int totalSecondes) {
    final int minutes = totalSecondes ~/ 60;
    final int secondes = totalSecondes % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondes.toString().padLeft(2, '0')}';
  }

  // Démarre ou met en pause le minuteur
  void demarrerOuMettreEnPause() {
    if (enCours) {
      mettreEnPause();
    } else {
      demarrerMinuteur();
    }
  }

  // Lance le Timer périodique
  void demarrerMinuteur() {
    if (secondesRestantes <= 0) return;

    timerInstance?.cancel();
    timerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondesRestantes <= 1) {
        timer.cancel();
        setState(() {
          secondesRestantes = 0;
          enCours = false;
          enPause = false;
        });
        afficherFin();
      } else {
        setState(() {
          secondesRestantes--;
        });
      }
    });

    setState(() {
      enCours = true;
      enPause = false;
    });
  }

  // Met le minuteur en pause
  void mettreEnPause() {
    timerInstance?.cancel();
    setState(() {
      enCours = false;
      enPause = true;
    });
  }

  // Réinitialise le minuteur à la durée initiale
  void reinitialiser() {
    timerInstance?.cancel();
    setState(() {
      secondesRestantes = dureeInitialeEnSecondes;
      enCours = false;
      enPause = false;
    });
  }

  // Sélectionne une durée prédéfinie
  void selectionnerPreset(int secondes) {
    if (enCours) return;
    setState(() {
      dureeInitialeEnSecondes = secondes;
      secondesRestantes = secondes;
      enPause = false;
    });
  }

  // Affiche le message de fin
  void afficherFin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Temps écoulé !')),
    );
  }

  @override
  void dispose() {
    timerInstance?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool enAlerte = secondesRestantes <= 5 && secondesRestantes > 0;
    final String affichageTemps =
        secondesRestantes == 0 ? 'Go !' : formaterSecondes(secondesRestantes);
    final String statutTexte = secondesRestantes == 0
        ? 'Terminé'
        : enCours
            ? 'En cours'
            : enPause
                ? 'En pause'
                : 'Prêt';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready ? Set Go !'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              affichageTemps,
              style: TextStyle(
                fontSize: 64,
                fontWeight: enAlerte ? FontWeight.bold : FontWeight.w600,
                color: enAlerte ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statutTexte,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                dureeButton('30s', 30),
                dureeButton('45s', 45),
                dureeButton('60s', 60),
                dureeButton('90s', 90),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: secondesRestantes > 0 ? demarrerOuMettreEnPause : null,
                  icon: Icon(enCours ? Icons.pause : Icons.play_arrow),
                  label: Text(enCours ? 'Pause' : 'Démarrer'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: reinitialiser,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réinitialiser'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bouton réutilisable pour les presets
  Widget dureeButton(String label, int secondes) {
    final bool actif = !enCours;
    return OutlinedButton(
      onPressed: actif ? () => selectionnerPreset(secondes) : null,
      child: Text(label),
    );
  }
}
