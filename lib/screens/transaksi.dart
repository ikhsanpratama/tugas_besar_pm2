import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:printing/printing.dart';

class TransactionReportPage extends StatefulWidget {
  const TransactionReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionReportPageState createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => isLoading = true);

    var query = supabase
        .from('transactions')
        .select('id, item_id, type, quantity, date, notes, items(name)')
        .order('date', ascending: false);

    if (startDate != null && endDate != null) {
      query = query.range(startDate!.millisecondsSinceEpoch, endDate!.millisecondsSinceEpoch);
    }

    final response = await query;
    setState(() {
      transactions = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
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
              Text('Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction['date']))}'),
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
              pw.Text('Laporan Transaksi Perangkat', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Perangkat', 'Jenis', 'Jumlah', 'Tanggal'],
                data: transactions.map((tx) => [
                  tx['items']['name'],
                  tx['type'],
                  tx['quantity'].toString(),
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(tx['date']))
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/Laporan_Transaksi.pdf');
    await file.writeAsBytes(await pdf.save());

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => startDate = picked);
                      fetchTransactions();
                    }
                  },
                  child: Text(startDate == null ? 'Dari' : DateFormat('yyyy-MM-dd').format(startDate!)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => endDate = picked);
                      fetchTransactions();
                    }
                  },
                  child: Text(endDate == null ? 'Sampai' : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
                ElevatedButton(
                  onPressed: generatePdfReport,
                  child: const Icon(Icons.print),
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
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }
}
