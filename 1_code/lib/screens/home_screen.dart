// Home Screen UI
// This is the first screen the user sees when they enter the website.
// Deliverable 1 focused on functionality; Deliverable 2 will enhance design.

import 'package:flutter/material.dart';
import 'package:code_1/widgets/centered_view.dart';
import 'package:code_1/services/auth_service.dart';
import 'package:code_1/services/user_service.dart';
import 'package:code_1/navbar/nav_bar.dart';
import 'resource_inventory_screen.dart';
import 'emergency_alerts_screen.dart';
import 'donation_screen.dart';
import 'request_posting_screen.dart';
import 'profile_screen.dart';
import 'create_request_screen.dart';
import 'volunteer_profile_screen.dart';
import 'request_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _userService = UserService();
  String? _userRole;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      final userRole = await _userService.getUserRole(token);
      if (mounted) {
        setState(() {
          _userRole = userRole;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load user data. Please try again.';
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadUserRole(); // Retry loading
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserRole,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Relief Platform'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await _authService.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              } catch (e) {
                if (mounted) {
                  _showErrorDialog('Failed to logout. Please try again.');
                }
              }
            },
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildContent() {
    switch (_userRole?.toLowerCase()) {
      case 'victim':
        return const RequestListScreen();
      case 'volunteer':
        return const VolunteerProfileScreen();
      case 'ngo':
        return const ResourceInventoryScreen();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Unknown user role'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserRole,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
    }
  }

  Widget? _buildFloatingActionButton() {
    if (_userRole?.toLowerCase() == 'victim') {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRequestScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
}



