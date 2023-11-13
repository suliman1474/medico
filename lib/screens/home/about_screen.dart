import 'package:flutter/material.dart';
import 'package:medico/core/text_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'about',
            style: customTexttheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
