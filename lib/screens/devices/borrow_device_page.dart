import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BorrowDevicePage extends StatefulWidget {
  final Map<String, dynamic> device;

  const BorrowDevicePage({super.key, required this.device});

  @override
  // ignore: library_private_types_in_public_api
  _BorrowDevicePageState createState() => _BorrowDevicePageState();
}

class _BorrowDevicePageState extends State<BorrowDevicePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController notesController = TextEditingController();

  Future<void> borrowDevice() async {
    await supabase.from('transactions').insert({
      'item_id': widget.device['id'],
      'user_id': supabase.auth.currentUser?.id,
      'type': 'borrow',
      'notes': notesController.text,
    });

    await supabase
        .from('items')
        .update({'status': 'in use'}).match({'id': widget.device['id']});

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perangkat dipinjam!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pinjam Perangkat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama Perangkat: ${widget.device['name']}',
                style: const TextStyle(fontSize: 18)),
            TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Catatan')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: borrowDevice, child: const Text('Pinjam Sekarang')),
          ],
        ),
      ),
    );
  }
}
