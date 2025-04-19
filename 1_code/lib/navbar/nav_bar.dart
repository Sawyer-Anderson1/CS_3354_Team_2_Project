import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Row with expanded space between logo and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo on the left
              SizedBox(
                height: 80,
                width: 150,
                child: Image.asset('assets/logo.png'),
              ),

              // Use Spacer to push the signup button to the right
              Expanded(
                child: Container(),
              ),

              // Sign-up button
              _HoverableSignInButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoverableSignInButton extends StatefulWidget {
  final VoidCallback onTap;
  // ignore: unused_element_parameter
  const _HoverableSignInButton({required this.onTap, super.key});

  @override
  State<_HoverableSignInButton> createState() => _HoverableSignInButtonState();
}

class _HoverableSignInButtonState extends State<_HoverableSignInButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.white;
    final hoverColor = Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              if (_isHovered)
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
            ],
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Sign Up / Sign In',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
