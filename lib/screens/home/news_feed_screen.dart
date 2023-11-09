import 'package:flutter/material.dart';
import 'package:medico/core/text_theme.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'newsfeed',
            style: customTexttheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
