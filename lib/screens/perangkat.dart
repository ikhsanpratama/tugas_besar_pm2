import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchItems();
  }

  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select('id, name');
    setState(() {
      categories = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> fetchItems() async {
    final response = await supabase
        .from('items')
        .select('id, name, category_id, status, created_at')
        .order('created_at', ascending: false);
    setState(() {
      items = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addItem(String name, String categoryId, String status) async {
    await supabase.from('items').insert({
      'name': name,
      'category_id': categoryId,
      'status': status,
      'created_at': DateTime.now().toIso8601String(),
    });
    fetchItems(); // Refresh daftar barang setelah menambah
  }

  void showAddItemDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String itemStatus = 'available';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Barang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            DropdownButton<String>(
              value: selectedCategoryId,
              hint: const Text('Pilih Kategori'),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
            DropdownButton<String>(
              value: itemStatus,
              items: ['available', 'in use', 'maintenance']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    itemStatus = value;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isEmpty || selectedCategoryId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama dan kategori harus diisi')),
                );
                return;
              }

              addItem(nameController.text, selectedCategoryId!, itemStatus);
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Barang')),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final category = categories.firstWhere(
                  (cat) => cat['id'] == item['category_id'],
                  orElse: () => {'name': 'Tidak Diketahui'},
                );
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Kategori: ${category['name']} | Status: ${item['status']}'),
                  trailing: const Icon(Icons.inventory),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
