import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
