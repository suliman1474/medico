import 'package:flutter/material.dart';
import 'package:medico/core/text_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'profile',
            style: customTexttheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
