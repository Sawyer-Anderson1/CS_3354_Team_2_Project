// UI for emergency alerts
// Creates a basics screen and imports the model and service darts for this specific function
// displays emergency alerts
// takes in the json data that is preloaded for delieverable 1
// in deliberable 2, will implemented a rotating emergency alerts that is randomized and displayed
// will be updated to stay on while emergency is active and for ones that are outdated/ dealt with, will say so

import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/emergency_alert_service.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyAlertsScreenState createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  late Future<List<Alert>> alerts;

  @override
  void initState() {
    super.initState();
    alerts =
        EmergencyAlertService.fetchEmergencyAlerts(); // Fetching alerts from local JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.deepPurple.shade600,
        title: const Text(
          'Emergency Alerts',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Alert>>(
        future: alerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No emergency alerts available.'));
          }

          final alertsList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alertsList.length,
            itemBuilder: (context, index) {
              final alert = alertsList[index];

              IconData icon;
              Color iconColor;

              switch (alert.alertTitle.toLowerCase()) {
                case 'flood warning':
                  icon = Icons.water_drop;
                  iconColor = Colors.blueAccent;
                  break;
                case 'earthquake warning':
                  icon = Icons.waves;
                  iconColor = Colors.brown;
                  break;
                case 'wildfire alert':
                  icon = Icons.local_fire_department;
                  iconColor = Colors.red;
                  break;
                case 'thunder watch':
                case 'hail watch':
                  icon = Icons.bolt;
                  iconColor = Colors.amber;
                  break;
                default:
                  icon = Icons.warning_amber_rounded;
                  iconColor = Colors.deepPurple;
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: iconColor.withOpacity(0.1),
                    child: Icon(icon, color: iconColor),
                  ),
                  title: Text(
                    alert.alertTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "${alert.alertDescription}\n\n📍 Location: ${alert.alertLocation}\n📅 Date: ${alert.alertDate}",
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
