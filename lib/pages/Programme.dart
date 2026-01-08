import 'package:flutter/material.dart';

// Modèle simple pour représenter un exercice
class Exercice {
  String nom;
  String details;
  bool effectue;

  Exercice({required this.nom, required this.details, this.effectue = false});
}

class Programme extends StatefulWidget {
  const Programme({super.key});

  @override
  State<Programme> createState() => ProgrammeState();
}

class ProgrammeState extends State<Programme> {
  final List<Exercice> exercices = [
    Exercice(nom: 'Pompes', details: '3 séries de 10'),
    Exercice(nom: 'Squats', details: '4 séries de 12'),
    Exercice(nom: 'Planche', details: '3 x 45 secondes'),
    Exercice(nom: 'Fentes', details: '3 séries de 10 par jambe'),
    Exercice(nom: 'Biceps', details: '4 séries de 12'),
    Exercice(nom: 'Triceps', details: '4 séries de 12'),
    Exercice(nom: 'Epaules', details: '3 séries de 10'),
    Exercice(nom: 'Abdominaux', details: '5 séries de 20'),
  ];

  final TextEditingController nomController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // Nettoie les contrôleurs lorsque le widget est retiré
  @override
  void dispose() {
    nomController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  // Ouvre la boîte de dialogue d'ajout d'exercice
  void ouvrirDialogueAjout() {
    nomController.clear();
    detailsController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un exercice"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: "Nom de l'exercice",
                ),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: "Détails (séries, reps, durée)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final String nom = nomController.text.trim();
                final String details = detailsController.text.trim();

                if (nom.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Le nom est obligatoire.")),
                  );
                  return;
                }

                setState(() {
                  exercices.add(
                    Exercice(
                      nom: nom,
                      details: details.isEmpty ? 'Sans détails' : details,
                      effectue: false,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Met à jour l'état "effectué" de l'exercice
  void basculerEffectue(int index, bool? valeur) {
    setState(() {
      exercices[index].effectue = valeur ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programme d'entraînement")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exercices.length,
              itemBuilder: (context, index) {
                final Exercice exercice = exercices[index];
                final TextStyle style = TextStyle(
                  decoration: exercice.effectue
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: exercice.effectue ? Colors.grey : Colors.black,
                );

                return ListTile(
                  leading: Checkbox(
                    value: exercice.effectue,
                    onChanged: (valeur) => basculerEffectue(index, valeur),
                  ),
                  title: Text(exercice.nom, style: style),
                  subtitle: Text(exercice.details, style: style),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ouvrirDialogueAjout,
        child: const Icon(Icons.add),
      ),
    );
  }
}
