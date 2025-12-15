import 'package:flutter/material.dart';
import 'package:gainz/services/service_quote.dart';

class Quote extends StatefulWidget {
  const Quote({super.key});

  @override
  State<Quote> createState() => QuoteState();
}

class QuoteState extends State<Quote> {
  final ServiceQuote service = ServiceQuote();
  String? quote;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  Future<void> loadQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String q = await service.quote();
      setState(() {
        quote = q;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        quote ??= "Stay strong";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Motivation ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),

          if (isLoading)
            const Text(
              "Chargement...",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
          else
            Text(quote ?? "Stay strong", style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: loadQuote,
              child: const Text("Nouvelle citation"),
            ),
          ),
        ],
      ),
    );
  }
}
