import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceStatisticsPage extends StatefulWidget {
  const DeviceStatisticsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceStatisticsPageState createState() => _DeviceStatisticsPageState();
}

class _DeviceStatisticsPageState extends State<DeviceStatisticsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  int available = 0;
  int inUse = 0;
  int maintenance = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeviceStatistics();
  }

  Future<void> fetchDeviceStatistics() async {
  try {
    final availableCount = await getItemCountByStatus('available');
    final inUseCount = await getItemCountByStatus('in use');
    final maintenanceCount = await getItemCountByStatus('maintenance');

    setState(() {
      available = availableCount;
      inUse = inUseCount;
      maintenance = maintenanceCount;
      isLoading = false;
    });
  // ignore: empty_catches
  } catch (e) {
  }
}

Future<int> getItemCountByStatus(String status) async {
  final response = await supabase
      .from('items')
      .select()
      .eq('status', status)
      .count(CountOption.exact);

  return response.count ?? 0; // Ensure return type is int
}

  List<PieChartSectionData> _buildChartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: available.toDouble(),
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: inUse.toDouble(),
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: maintenance.toDouble(),
        title: '',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Perangkat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Perangkat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _buildChartSections(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildStatCard('Available', Colors.green, available),
                _buildStatCard('In Use', Colors.blue, inUse),
                _buildStatCard('Maintenance', Colors.red, maintenance),
              ],
            ),
    );
  } 

  Widget _buildStatCard(String label, Color color, int count) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 10),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
