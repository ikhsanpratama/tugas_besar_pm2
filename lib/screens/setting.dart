import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image widget
            Image.asset(
              'assets/tech.jpg', // Replace with your image asset path
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20), // Spacing between image and text
            // Text widget
            const Text(
              'Stay tuned. Something big is coming!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
          child: Center(
        child: Text("Pemograman Mobile 2",
            style: TextStyle(fontStyle: FontStyle.italic)),
      )),
    );
  }
}
