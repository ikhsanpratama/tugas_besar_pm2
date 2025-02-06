import 'package:flutter/material.dart';
import 'package:tugas_besar_pm2/screens/account/user_management.dart';
import 'package:tugas_besar_pm2/screens/auth/auth_service.dart';
import 'package:tugas_besar_pm2/screens/categories.dart';
// import 'package:tugas_besar_pm2/screens/about.dart';
// import 'package:tugas_besar_pm2/screens/category_form.dart';
import 'package:tugas_besar_pm2/screens/opname.dart';
import 'package:tugas_besar_pm2/screens/perangkat.dart';
import 'package:tugas_besar_pm2/screens/status.dart';
import 'package:tugas_besar_pm2/screens/transaksi.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Status Perangkat',
      'icon': Icons.data_usage,
      'color': Colors.redAccent,
      'page': const StatusPerangkat()
    },
    {
      'title': 'Transaksi',
      'icon': Icons.pin_end_sharp,
      'color': Colors.amber,
      'page': const TransactionsPage()
    },
    {
      'title': 'Maintenance',
      'icon': Icons.widgets,
      'color': Colors.green,
      'page': const OpnamePerangkat()
    },
  ];

  final authService = AuthService();
  void logout() async {
    await authService.signOut();
  }

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String?>(
                    future: authService.getUserName(), 
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Text('Gagal mengambil nama pengguna');
                      }
                      return Text('User : ${snapshot.data}');
                    }),                  
                  FutureBuilder<String?>(
                    future: authService.getUserRole(), 
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Text('Gagal mengambil role pengguna');
                      }
                      return Text('Jabatan : ${snapshot.data}');
                    }),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              selected: true,
              selectedTileColor: Colors.lightBlue,
              enabled: false,
              title: const Text(
                'Beranda',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              onTap: () {
                null;
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Perangkat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ItemsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Kategori Perangkat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Pengguna'),
              // trailing: current,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserManagementPage()),
                );
              },
            ),
            const Divider(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              textColor: Colors.red,
              title: const Text('Keluar'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return Card(
              semanticContainer: true,
              color: item['color'],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['page']),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 100,
                      color: Colors.white,
                      applyTextScaling: true,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
