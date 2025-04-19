import 'package:flutter/material.dart';

class UserStoriesWidget extends StatefulWidget {
  const UserStoriesWidget({super.key});

  @override
  State<UserStoriesWidget> createState() => _UserStoriesWidgetState();
}

class _UserStoriesWidgetState extends State<UserStoriesWidget> {
  int _currentIndex = 0;

  final List<String> _stories = [
    '“After the hurricane, I had no food or water. Thanks to this Crowdsourced Disaster Relief System, I received supplies within a day. Never would I have imagined help would come this fast!” - Maria, Plano',
    '“The donation process was super easy. It feels great knowing my support reached families in need.” - Ahmed, Allen',
    '“I posted a request when our shelter ran out of blankets. Volunteers responded within hours.” - Jenna, Frisco',
    '“Getting real-time emergency alerts helped my family evacuate safely during the flood.” - Samuel, Garland',
  ];

  void _nextStory() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _stories.length;
    });
  }

  void _prevStory() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _stories.length) % _stories.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Read How We Contribute',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          constraints: const BoxConstraints(
            minHeight: 150,
            maxWidth: 800,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _stories[_currentIndex],
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _prevStory,
              icon: const Icon(Icons.arrow_back_ios),
              tooltip: 'Previous Story',
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: _nextStory,
              icon: const Icon(Icons.arrow_forward_ios),
              tooltip: 'Next Story',
            ),
          ],
        ),
      ],
    );
  }
}

