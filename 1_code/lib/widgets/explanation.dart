import 'package:flutter/material.dart';

class ExplanationWidget extends StatelessWidget {
  const ExplanationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'How Crowdsourcing Works',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Text(
            'Crowdsourcing in disaster relief empowers individuals to both request and offer help in real-time. '
            'Those in need post requests for supplies or services, while volunteers and donors from nearby communities or across the globe respond. '
            'This decentralized system ensures faster response, better resource allocation, and community-driven action. '
            'By using technology to connect people directly, crowdsourcing enables quick, efficient, and compassionate relief.',
            style: TextStyle(fontSize: 17, height: 1.6),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
