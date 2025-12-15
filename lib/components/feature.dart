import 'package:flutter/material.dart';

class FeatureWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed; // 👈 tu ajoutes ceci

  const FeatureWidget({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed, // 👈 et ceci
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // 👈 c'est ici que se fait le clic
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // pour enlever les marges du bouton
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
