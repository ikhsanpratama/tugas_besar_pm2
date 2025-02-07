import 'package:flutter/material.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';

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
              'Tugas Besar Mata Kuliah Pemograman Mobile 2 - FLutter',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dosen : Andri Nugraha Ramdhon, S.Kom., M.Kom.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Expanded(
              child: ScrollableTextIndicator(                
                text: Text(
                  'Tujuan Pembuatan Aplikasi ini untuk mencatat, mengelola, dan memantau perangkat IT seperti access point, server, router, atau perangkat lainnya. Aplikasi ini memungkinkan pengguna untuk melihat status perangkat, mengelola peminjaman, melakukan pemeliharaan pada perangkat, dan membuat laporan-laporan terkait perangkat.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                indicatorBarColor: Colors.amber,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Version 1.0.0',
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
