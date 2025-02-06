import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionPage extends StatefulWidget {
  final String currentUserId; // ID pengguna yang sedang login

  const TransactionPage({super.key, required this.currentUserId});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? scannedDevice;
  bool isLoading = false;

  Future<void> fetchDeviceById(String deviceId) async {
    setState(() => isLoading = true);

    final response = await supabase
        .from('items')
        .select('*')
        .eq('id', deviceId)
        .maybeSingle();

    setState(() {
      scannedDevice = response;
      isLoading = false;
    });
  }

  Future<void> processTransaction(String type) async {
    if (scannedDevice == null) return;

    String deviceId = scannedDevice!['id'];
    print("QR Code Scanned: $deviceId");

    // Simpan transaksi ke tabel transactions
    await supabase.from('transactions').insert({
      'item_id': deviceId.toString(),
      'user_id': widget.currentUserId,
      'type': type,
      'date': DateTime.now().toIso8601String(),
      'notes': type == 'borrow' ? 'Perangkat dipinjam' : 'Perangkat dihapus',
    });

    // Update status perangkat jika transaksi adalah peminjaman
    if (type == 'borrow') {
      await supabase
          .from('items')
          .update({'status': 'in use'}).match({'id': deviceId});
    } else if (type == 'delete') {
      await supabase.from('items').delete().match({'id': deviceId});
    }

    setState(() {
      scannedDevice = null;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              type == 'borrow' ? 'Perangkat dipinjam' : 'Perangkat dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Perangkat')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  String deviceId = barcodes.first.rawValue ?? "";
                  print("QR Code Scanned: $deviceId");
                  if (deviceId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("QR Code tidak valid!")),
                    );
                    return;
                  }
                  await fetchDeviceById(deviceId);
                }
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : scannedDevice != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Perangkat: ${scannedDevice!['name']}',
                              style: const TextStyle(fontSize: 18)),
                          Text('Status: ${scannedDevice!['status']}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => processTransaction('borrow'),
                                child: const Text('Pinjam'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => processTransaction('delete'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('Hapus',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const Center(child: Text('Scan QR Code perangkat')),
          ),
        ],
      ),
    );
  }
}
