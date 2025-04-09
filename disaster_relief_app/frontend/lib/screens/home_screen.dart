import 'package:flutter/material.dart';
import 'resource_inventory_screen.dart';
import 'emergency_alerts_screen.dart';
import 'donation_screen.dart';
import 'request_posting_screen.dart';
import 'profile_screen.dart' ;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crowdsourced Disaster Relief System',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align to top
          crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
          children: [
            const SizedBox(height: 18), // Add some space between title and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResourceInventoryScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  ),
                  child: const Text(
                    'See Available Resource Inventory',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestPostingScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Request for Help',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Donate Now!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 235, 93, 93),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmergencyAlertsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'See Emergency Alerts',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'SignUp/SignIn',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



