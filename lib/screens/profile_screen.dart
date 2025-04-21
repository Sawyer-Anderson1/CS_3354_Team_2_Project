// UI for signup / sign in 
// Creates a basics screen and imports the model and service darts for this specific function
// toggles between sign in and sign out 
// user enters email and password
// not integrated yet for data storage in the backend so user will get an error message after signing in
// will be integrated with database and backend for deliverable 2 
// this screen simply lays the groundwork for user sign in and sign out 

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = true; // Toggle between sign up and sign in

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        if (_isSignUp) {
          final user = User(email: email, password: password);
          final success = await AuthService().signUp(user);

          if (success && mounted) {
            // Make sure the context is still valid
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Successful')));
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Failed')));
          }
        } else {
          final success = await AuthService().signIn(email, password);

          if (success && mounted) {
            // Make sure the context is still valid
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign In Successful')));
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign In Failed')));
          }
        }
      } catch (e) {
        // Handle any errors (like network issues)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                  });
                },
                child: Text(_isSignUp
                    ? 'Already have an account? Sign in'
                    : 'Don’t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

