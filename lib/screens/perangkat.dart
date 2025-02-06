import 'package:flutter/material.dart';

class Perangkat extends StatelessWidget {
  final List<KategoriPerangkat> katPerangkat = [
    KategoriPerangkat(kategori: 'Switch', jumlahPerangkat: 20),
    KategoriPerangkat(kategori: 'Access Point', jumlahPerangkat: 85),
    KategoriPerangkat(kategori: 'Router', jumlahPerangkat: 12),
    KategoriPerangkat(kategori: 'Server', jumlahPerangkat: 3),
    // Tambahkan kategori lainnya sesuai kebutuhan
  ];

  Perangkat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jumlah Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: katPerangkat.length,
        itemBuilder: (context, index) {
          final kategori = katPerangkat[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(kategori.kategori),
              trailing: Text('${kategori.jumlahPerangkat} perangkat'),
            ),
          );
        },
      ),
    );
  }
}

class KategoriPerangkat {
  final String kategori;
  final int jumlahPerangkat;

  KategoriPerangkat({required this.kategori, required this.jumlahPerangkat});
}
