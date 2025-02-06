import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryId;
  String? selectedItemId;
  String transactionType = 'remove';
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

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
    final response = await supabase.from('items').select('id, name, category_id');
    setState(() {
      items = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addTransaction() async {
    final user = supabase.auth.currentUser;
    if (user != null && selectedItemId != null && quantityController.text.isNotEmpty) {
      await supabase.from('transactions').insert({
        'item_id': selectedItemId,
        'user_id': user.id,
        'type': transactionType,
        'quantity': int.parse(quantityController.text),
        'notes': notesController.text,
        'date': DateTime.now().toIso8601String(),
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              value: selectedItemId,
              hint: const Text('Pilih Barang'),
              items: items
                  .where((item) =>
                      selectedCategoryId == null || item['category_id'] == selectedCategoryId)
                  .map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'],
                  child: Text(item['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedItemId = value;
                });
              },
            ),
            DropdownButton<String>(
              value: transactionType,
              items: ['remove', 'borrow']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  transactionType = value!;
                });
              },
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Catatan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTransaction,
              child: const Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
