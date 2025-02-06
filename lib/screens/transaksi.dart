import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_transaction_page.dart'; // Import halaman tambah transaksi

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await supabase
        .from('transactions')
        .select('id, type, quantity, date, notes, items(name)')
        .order('date', ascending: false);
    
    setState(() {
      transactions = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Transaksi Barang')),
      body: transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text('${transaction['items']['name']}'),
                  subtitle: Text(
                      '${transaction['type']} - ${transaction['quantity']} item\n${transaction['date']}'),
                  trailing: const Icon(Icons.receipt_long),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddTransactionPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
