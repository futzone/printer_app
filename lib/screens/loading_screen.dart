import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

showLoadingDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const LoadingScreen();
    },
  );
}
