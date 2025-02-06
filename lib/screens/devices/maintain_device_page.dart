import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaintainDevicePage extends StatefulWidget {
  final Map<String, dynamic> device;

  const MaintainDevicePage({super.key, required this.device});

  @override
  // ignore: library_private_types_in_public_api
  _MaintainDevicePageState createState() => _MaintainDevicePageState();
}

class _MaintainDevicePageState extends State<MaintainDevicePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController notesController = TextEditingController();
  String selectedStatus = 'pending';

  Future<void> maintainDevice() async {
    await supabase.from('maintenances').insert({
      'item_id': widget.device['id'],
      'status': selectedStatus,
      'notes': notesController.text,
    });

    // Jika status pemeliharaan "completed", ubah status perangkat menjadi "available"
    if (selectedStatus == 'completed') {
      await supabase
          .from('items')
          .update({'status': 'available'}).match({'id': widget.device['id']});
    } else {
      await supabase
          .from('items')
          .update({'status': 'maintenance'}).match({'id': widget.device['id']});
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status pemeliharaan diperbarui!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemeliharaan Perangkat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama Perangkat: ${widget.device['name']}',
                style: const TextStyle(fontSize: 18)),
            TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Catatan')),
            DropdownButton<String>(
              value: selectedStatus,
              items: ['pending', 'in progress', 'completed'].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedStatus = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: maintainDevice,
                child: const Text('Simpan Pemeliharaan')),
          ],
        ),
      ),
    );
  }
}
