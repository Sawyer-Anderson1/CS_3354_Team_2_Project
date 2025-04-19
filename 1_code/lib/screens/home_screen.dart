// Home Screen UI
// This is the first screen the user sees when they enter the website.
// Deliverable 1 focused on functionality; Deliverable 2 will enhance design.

import 'package:flutter/material.dart';
import 'package:code_1/widgets/centered_view.dart';
import 'resource_inventory_screen.dart';
import 'emergency_alerts_screen.dart';
import 'donation_screen.dart';
import 'request_posting_screen.dart';
import 'package:code_1/navbar/nav_bar.dart';
import '../widgets/intro.dart';
import '../widgets/intro2.dart';
import '../widgets/user_stories.dart'; 
import '../widgets/explanation.dart'; 
import '../widgets/contact.dart'; 
import '../widgets/social.dart'; 
import '../widgets/team.dart';    

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward(); 
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF), // white
              Color(0xFFE0F7FA), // very light blue
              Color(0xFFB2EBF2), // soft sky blue
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: CenteredView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomNavigationBar(),
                const SizedBox(height: 18),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 18.0,
                      runSpacing: 18.0,
                      children: [
                        _animatedButton(
                          label: 'See Available Resource Inventory',
                          page: const ResourceInventoryScreen(),
                        ),
                        _animatedButton(
                          label: 'See Emergency Alerts',
                          page: const EmergencyAlertsScreen(),
                        ),
                        _animatedButton(
                          label: 'Request for Help',
                          page: const RequestPostingScreen(),
                        ),
                        _animatedButton(
                          label: 'Donate Now!',
                          page: const DonationScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(child: Intro()),   // Left side
                      Expanded(child: Intro2()),  // Right side
                    ],
                  ),
                ),
                const SizedBox(height: 120),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const UserStoriesWidget(),
                ),
                const SizedBox(height: 120),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const ExplanationWidget(),
                ),
                const SizedBox(height: 120),
                // Updated Row with Social and Team Widgets wrapped in a Wrap widget
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 22.0, // Space between widgets
                    runSpacing: 22.0, // Space between rows
                    children: [
                      Flexible(
                        child: SocialWidget(),  // Left Widget (SocialWidget)
                      ),
                      Flexible(
                        child: ContactInfoWidget(),  // Middle Widget (ContactInfoWidget)
                      ),
                      Flexible(
                        child: TeamWidget(),  // Right Widget (TeamWidget)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedButton({required String label, required Widget page}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
