import 'package:flutter/material.dart';
import 'package:medico/core/text_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'Home',
            style: customTexttheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
