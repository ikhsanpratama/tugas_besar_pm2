import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  const MaintenanceHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MaintenanceHistoryPageState createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> maintenanceHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMaintenanceHistory();
  }

  Future<void> fetchMaintenanceHistory() async {
    try {
      final response = await supabase
          .from('maintenances')
          .select('id, item_id, start_date, end_date, status, notes, items(name)')
          .order('start_date', ascending: false);

      setState(() {
        maintenanceHistory = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching maintenance history: $e");
    }
  }

  void showMaintenanceDetails(Map<String, dynamic> maintenance) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail Maintenance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Perangkat: ${maintenance['items']['name']}'),
              Text('Status: ${maintenance['status']}'),
              Text('Mulai: ${maintenance['start_date']}'),
              Text('Selesai: ${maintenance['end_date'] ?? 'Belum selesai'}'),
              Text('Catatan: ${maintenance['notes'] ?? 'Tidak ada'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Maintenance')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: maintenanceHistory.length,
              itemBuilder: (context, index) {
                final maintenance = maintenanceHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(maintenance['items']['name']),
                    subtitle: Text(
                      'Status: ${maintenance['status']} | ${maintenance['start_date']}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => showMaintenanceDetails(maintenance),
                  ),
                );
              },
            ),
    );
  }
}
