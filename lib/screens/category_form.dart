// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_besar_pm2/screens/categories.dart';

class CategoryFormScreen extends StatefulWidget {
  final Map<String, dynamic>? category;

  // ignore: prefer_const_constructors_in_immutables
  CategoryFormScreen({super.key, this.category});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _nameController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!['name'];     
    }
  }

  Future<void> saveCategory() async {
    final name = _nameController.text;    

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name is required')));
      return;
    }

    if (widget.category == null) {
      // Create new category
      try{
        await _supabase.from('categories').insert({
        'name': name,
        });
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryListScreen()),
                );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambah Kategori Berhasil')));
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambah Kategori Gagal')));
      }            
    } else {
      // Update existing category
      try{
      await _supabase.from('categories').update({
              'name': name,
            }).eq('id', widget.category!['id']);
      Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryListScreen()),
                );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Kategori Berhasil')));
      }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Kategori Gagal')));
      }
      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        backgroundColor: Colors.lightBlue,
      ),
      // appBar: AppBar(title: Text(widget.category == null ? 'Add Category' : 'Edit Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveCategory,
              child: Text(widget.category == null ? 'Tambah Kategori' : 'Edit Kategori'),
            ),
          ],
        ),
      ),
    );
  }
}
