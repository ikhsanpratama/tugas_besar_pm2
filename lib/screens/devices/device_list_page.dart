import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'device_add_page.dart';
import 'device_detail_page.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  // List<Map<String, dynamic>> devices = [];
  Map<String, List<Map<String, dynamic>>> categorizedDevices = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }
  
  Future<void> fetchDevices() async {
    final response = await supabase
        .from('items')
        .select('id, name, description, status, categories(name)');

    if (response.isNotEmpty) {
      Map<String, List<Map<String, dynamic>>> groupedDevices = {};

      for (var item in response) {
        String categoryName = item['categories']['name'] ?? 'Tanpa Kategori';

        if (!groupedDevices.containsKey(categoryName)) {
          groupedDevices[categoryName] = [];
        }
        groupedDevices[categoryName]!.add(item);
      }

      setState(() {
        categorizedDevices = groupedDevices;
        isLoading = false;
      });
    } else {
      setState(() {
        categorizedDevices = {};
        isLoading = false;
      });
    }
  }

  Future<void> deleteDevice(String id) async {
    await supabase.from('items').delete().match({'id': id});
    fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categorizedDevices.isEmpty
              ? const Center(child: Text('Tidak ada perangkat tersedia'))
              : ListView.builder(
                  itemCount: categorizedDevices.keys.length,
                  itemBuilder: (context, index) {
                    String category = categorizedDevices.keys.elementAt(index);
                    List<Map<String, dynamic>> devices =
                        categorizedDevices[category]!;

                    return ExpansionTile(
                      title: Text(category,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: devices.map((device) {
                        return ListTile(
                          title: Text(device['name']),
                          subtitle: Text('Status: ${device['status']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteDevice(device['id']),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DeviceDetailPage(device: device),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(        
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeviceAddPage()),
        ).then((_) => fetchDevices()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
