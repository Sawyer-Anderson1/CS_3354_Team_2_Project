import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget {
  const SocialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: 300,
        height: 410,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Social Media',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                ContactItem(
                  label: 'Instagram',
                  value: '@CrowdsourcedDisasterRelief',
                ),
                SizedBox(height: 20),
                ContactItem(
                  label: 'X',
                  value: '@CrowdsourcedDisasterRelief',
                ),
                SizedBox(height: 20),
                ContactItem(
                  label: 'Facebook',
                  value: '@CrowdsourcedDisasterRelief',
                ),
                SizedBox(height: 20),
                ContactItem(
                  label: 'Tiktok',
                  value: '@CrowdsourcedDisasterRelief',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final String label;
  final String value;

  const ContactItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}



