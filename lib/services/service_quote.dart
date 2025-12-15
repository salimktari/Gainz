import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class ServiceQuote {
  final _random = Random();
  final List<String> _fallbackQuotes = const [
    "Le progrès n'est pas linéaire, avance un jour après l'autre.",
    "Chaque répétition te rapproche de ton objectif.",
    "Les excuses brûlent zéro calorie.",
    "La discipline bat la motivation, surtout les jours difficiles.",
    "Tu n'as jamais regretté d'avoir terminé une séance.",
  ];

  Future<String> quote() async {
    try {
      final url = Uri.parse('https://api.quotable.io/random');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final content = data['content'] as String?;
        final author = data['author'] as String?;

        if (content != null && content.isNotEmpty) {
          if (author != null && author.isNotEmpty) {
            return "$content — $author";
          }
          return content;
        }
      }
    } catch (_) {
      // ignore and fall back to a local quote
    }

    return _fallbackQuotes[_random.nextInt(_fallbackQuotes.length)];
  }
}
