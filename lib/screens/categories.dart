// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_besar_pm2/screens/category_form.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final _future = Supabase.instance.client.from('categories').select();
  // late Future<List<Map<String, dynamic>>> _categories;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kategori Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category['name']),                
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteCategory(category['id']),
                  // onPressed: () => log(category['id']),
                ),
                onTap: () => navigateToEditCategoryScreen(category),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddCategoryScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    await Supabase.instance.client.from('categories').delete().eq('id', id);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CategoryListScreen()),
    );
  }

  void navigateToAddCategoryScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CategoryFormScreen()),
    );
  }

  void navigateToEditCategoryScreen(Map<String, dynamic> category) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFormScreen(category: category),
      ),
    );
  }
}
