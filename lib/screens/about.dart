import 'package:flutter/material.dart';

class AboutUts extends StatelessWidget {
  const AboutUts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/inventory.png',
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'IT Inventory Mobile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tugas UTS Mata Kuliah Pemograman Mobile 2 - FLutter',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dosen : Andri Nugraha Ramdhon, S.Kom., M.Kom.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Aplikasi ini dirancang untuk mencatat, mengelola, dan memantau perangkat IT seperti access point, server, router, atau perangkat lainnya. Aplikasi ini memungkinkan pengguna untuk memantau status perangkat, mengelola peminjaman, dan menghasilkan laporan inventaris.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Text(
              'Version 0.3.0',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
