import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tugas_besar_pm2/screens/devices/borrow_device_page.dart';
import 'maintain_device_page.dart';

class DeviceDetailPage extends StatelessWidget {
  final Map<String, dynamic> device;
  const DeviceDetailPage({super.key, required this.device});

  void _printQrCode(BuildContext context) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("QR Code Perangkat",
                    style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 10),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: device['id'],
                  width: 150,
                  height: 150,
                ),
                pw.SizedBox(height: 10),
                pw.Text("ID: ${device['id']}",
                    style: const pw.TextStyle(fontSize: 16)),
                pw.Text("Nama: ${device['name']}",
                    style: const pw.TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isInUse = device['status'] == 'in use'; // 🔹 Status "in use"
    bool isMaintenance =
        device['status'] == 'maintenance'; // 🔹 Status "maintenance"

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${device['name']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Deskripsi: ${device['description'] ?? 'Tidak ada'}'),
            Text('Kategori: ${device['categories']['name']}'),
            Text('Status: ${device['status']}'),
            const SizedBox(height: 20),
            Center(
              child: QrImageView(
                data: device['id'],
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _printQrCode(context),
                icon: const Icon(Icons.print),
                label: const Text("Cetak QR Code"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.assignment),
                  label: const Text('Transaksi'),
                  onPressed: isMaintenance
                      ? null // 🔹 Disabled jika status "maintenance"
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BorrowDevicePage(device: device)),
                          );
                        },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.build),
                  label: const Text('Pemeliharaan'),
                  onPressed: isInUse
                      ? null // 🔹 Disabled jika status "in use"
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MaintainDevicePage(device: device)),
                          );
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
