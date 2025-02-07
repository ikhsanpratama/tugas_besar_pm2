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
  bool isAlreadyInMaintenance = false;

  @override
  void initState() {
    super.initState();
    checkMaintenanceStatus();
  }

  Future<void> checkMaintenanceStatus() async {
    final response = await supabase
        .from('maintenances')
        .select('status')
        .eq('item_id', widget.device['id'])
        .neq('status', 'completed')
        .maybeSingle();

    setState(() {
      if (response != null) {
        isAlreadyInMaintenance = true;
        selectedStatus = 'completed'; // Jika sudah dalam maintenance, default ke completed
      } else {
        isAlreadyInMaintenance = false;
        selectedStatus = 'pending'; // Default ke pending jika belum ada
      }
    });
  }

  Future<void> maintainDevice() async {
    if (selectedStatus == 'completed') {
      // 🔹 Update status perangkat ke `available` dan tandai maintenance selesai
      await supabase
          .from('items')
          .update({'status': 'available'})
          .match({'id': widget.device['id']});

      await supabase
          .from('maintenances')
          .update({
            'status': 'completed',
            'end_date': DateTime.now().toIso8601String(),
          })
          .match({'item_id': widget.device['id'], 'status': 'in progress'});
    } else {
      // 🔹 Jika belum ada maintenance, masukkan ke dalam tabel `maintenances`
      await supabase.from('maintenances').insert({
        'item_id': widget.device['id'],
        'status': selectedStatus,
        'notes': notesController.text,
        'start_date': DateTime.now().toIso8601String(),
      });

      await supabase
          .from('items')
          .update({'status': 'maintenance'})
          .match({'id': widget.device['id']});
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
      appBar: AppBar(
        title: const Text(
          'Pemeliharaan Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
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
              items: isAlreadyInMaintenance
                  ? ['completed']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList()
                  : ['pending', 'in progress']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
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
