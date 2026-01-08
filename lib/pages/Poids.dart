import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Page de suivi du poids avec saisie et historique Firestore
class Poids extends StatefulWidget {
  const Poids({super.key});

  @override
  State<Poids> createState() => PoidsState();
}

class PoidsState extends State<Poids> {
  final TextEditingController poidsController = TextEditingController();

  // Nettoie le contrôleur à la destruction du widget
  @override
  void dispose() {
    poidsController.dispose();
    super.dispose();
  }

  // Formatte la date en style français jj/MM/yyyy HH:mm
  String formaterDate(Timestamp? timestamp) {
    final DateTime date = timestamp != null
        ? timestamp.toDate()
        : DateTime.now();
    final String jour = date.day.toString().padLeft(2, '0');
    final String mois = date.month.toString().padLeft(2, '0');
    final String annee = date.year.toString();
    final String heures = date.hour.toString().padLeft(2, '0');
    final String minutes = date.minute.toString().padLeft(2, '0');
    return '$jour/$mois/$annee $heures:$minutes';
  }

  // Enregistre le poids saisi dans Firestore
  Future<void> enregistrerPoids() async {
    final User? utilisateur = FirebaseAuth.instance.currentUser;
    if (utilisateur == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Merci de vous connecter.')));
      return;
    }

    final String saisie = poidsController.text.trim();
    if (saisie.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entrez votre poids.')));
      return;
    }

    final double? poids = double.tryParse(saisie.replaceAll(',', '.'));
    if (poids == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Valeur invalide.')));
      return;
    }

    if (poids < 20 || poids > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez un poids entre 20 et 300 kg.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('poids').add({
      'userId': utilisateur.uid,
      'valeur': poids,
      'date': Timestamp.now(),
    });

    poidsController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Poids enregistré avec succès.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? utilisateur = FirebaseAuth.instance.currentUser;

    if (utilisateur == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Suivi du poids')),
        body: const Center(
          child: Text('Connectez-vous pour suivre votre poids.'),
        ),
      );
    }

    final Query<Map<String, dynamic>> historiqueQuery = FirebaseFirestore
        .instance
        .collection('poids')
        .where('userId', isEqualTo: utilisateur.uid)
        .orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Suivi du poids')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: historiqueQuery.limit(1).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Erreur de chargement : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );
                }

                if (docs.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Poids actuel : -- kg',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Aucun poids enregistré pour le moment.'),
                        ],
                      ),
                    ),
                  );
                }

                final data = docs.first.data();
                final double? valeur = data['valeur'] is int
                    ? (data['valeur'] as int).toDouble()
                    : data['valeur'] as double?;
                final Timestamp? date = data['date'] as Timestamp?;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poids actuel : ${valeur?.toStringAsFixed(1) ?? '--'} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date != null
                              ? 'Dernière mise à jour : ${formaterDate(date)}'
                              : 'Dernière mise à jour : en cours...',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: poidsController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Entrer votre poids (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: enregistrerPoids,
                child: const Text('Enregistrer mon poids'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Historique',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: historiqueQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur de chargement : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Aucun poids enregistré pour le moment.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      final double? valeur = data['valeur'] is int
                          ? (data['valeur'] as int).toDouble()
                          : data['valeur'] as double?;
                      final Timestamp? date = data['date'] as Timestamp?;

                      return Card(
                        child: ListTile(
                          title: Text(
                            '${valeur?.toStringAsFixed(1) ?? '--'} kg',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            date != null ? formaterDate(date) : 'Date inconnue',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
