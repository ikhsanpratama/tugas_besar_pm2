import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceAddPage extends StatefulWidget {
  const DeviceAddPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceAddPageState createState() => _DeviceAddPageState();
}

class _DeviceAddPageState extends State<DeviceAddPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategoryId = '';
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select('*');
    setState(() {
      categories = List<Map<String, dynamic>>.from(response);
      if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
    });
  }

  Future<void> addDevice() async {
    if (nameController.text.isEmpty || selectedCategoryId.isEmpty) return;

    await supabase.from('items').insert({
      'name': nameController.text,
      'description': descriptionController.text,
      'category_id': selectedCategoryId,
      'status': 'available',
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Perangkat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Perangkat')),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi')),
            DropdownButton<String>(
              value: selectedCategoryId,
              items: categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['id'].toString(), // Pastikan ini String
                  child: Text(category['name'].toString()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedCategoryId = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addDevice, child: const Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
