// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class TransaksiPerangkat extends StatefulWidget {
  const TransaksiPerangkat({super.key});

  @override
  _TransaksiPerangkatState createState() => _TransaksiPerangkatState();
}

class _TransaksiPerangkatState extends State<TransaksiPerangkat> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTransactionType = "Tambah";
  final TextEditingController _namaPerangkatController =
      TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _peminjamController = TextEditingController();
  DateTime? _selectedDate;

  // Function to show a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi Perangkat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for transaction type
              const Text(
                "Jenis Transaksi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedTransactionType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTransactionType = newValue!;
                  });
                },
                items: ["Tambah", "Pengurangan", "Peminjaman"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
              const SizedBox(height: 16),
              // Input for device name
              const Text(
                "Nama Perangkat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _namaPerangkatController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nama perangkat",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama perangkat tidak boleh kosong.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input for quantity
              const Text(
                "Jumlah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan jumlah perangkat",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah perangkat tidak boleh kosong.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input for borrower name (only for borrowing)
              if (_selectedTransactionType == "Peminjaman") ...[
                const Text(
                  "Nama Peminjam",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _peminjamController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukkan nama peminjam",
                  ),
                  validator: (value) {
                    if (_selectedTransactionType == "Peminjaman" &&
                        (value == null || value.isEmpty)) {
                      return "Nama peminjam tidak boleh kosong.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tanggal Pengembalian",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "Belum dipilih"
                            : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit logic here
                    toastification.show(
                        context: context,
                        alignment: Alignment.bottomCenter,
                        style: ToastificationStyle.flatColored,
                        type: ToastificationType.success,
                        showIcon: true,
                        icon: const Icon(Icons.checklist),
                        title: const Text('Transaksi berhasil dicatat'),
                        showProgressBar: false,
                        autoCloseDuration: const Duration(seconds: 3),
                        closeButtonShowType: CloseButtonShowType.none);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Simpan Transaksi",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
