import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tugas_besar_pm2/screens/transaksi_add.dart';

class TransactionReportPage extends StatefulWidget {
  const TransactionReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionReportPageState createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => isLoading = true);

    try {
      // 🔹 Ambil semua transaksi dari Supabase
      final response = await supabase
          .from('transactions')
          .select('id, item_id, type, quantity, date, notes, items(name)')
          .order('date', ascending: false);

      setState(() {
        transactions = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Perangkat: ${transaction['items']['name']}'),
              Text('Jenis: ${transaction['type']}'),
              Text('Jumlah: ${transaction['quantity']}'),
              Text(
                  'Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction['date']))}'),
              Text('Catatan: ${transaction['notes'] ?? 'Tidak ada catatan'}'),
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

  Future<void> generatePdfReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Laporan Transaksi Perangkat',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Perangkat', 'Jenis', 'Jumlah', 'Tanggal'],
                data: transactions
                    .map((tx) => [
                          tx['items']['name'],
                          tx['type'],
                          tx['quantity'].toString(),
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(DateTime.parse(tx['date']))
                        ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Transaksi Perangkat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: generatePdfReport,
                  child: const Row(
                    children: [
                      Icon(Icons.print),
                      SizedBox(width: 5),
                      Text('Cetak Laporan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(transaction['items']['name']),
                          subtitle: Text(
                            '${transaction['type']} | ${transaction['quantity']} item\n${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction['date']))}',
                          ),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () => showTransactionDetails(transaction),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TransactionPage(
                    currentUserId: '',
                  )),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
