// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class OpnamePerangkat extends StatefulWidget {
  const OpnamePerangkat({super.key});

  @override
  _OpnamePerangkatState createState() => _OpnamePerangkatState();
}

class _OpnamePerangkatState extends State<OpnamePerangkat> {
  final List<Map<String, dynamic>> _schedules = [
    {
      "date": "03-12-2024",
      "time": "10:00",
      "description": "Opname Rutin Bulanan"
    },
    {
      "date": "04-12-2024",
      "time": "15:00",
      "description": "Opname Perangkat Hibah"
    },
    {
      "date": "05-12-2024",
      "time": "09:00",
      "description": "Opname Access Point Ruijie"
    },
  ];

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _addScheduleDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Jadwal"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Tanggal",
                    hintText: "Pilih tanggal",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2050),
                    );
                    setState(() {
                      _dateController.text =
                          "${pickedDate!.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Waktu",
                    hintText: "Pilih waktu",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _timeController.text =
                            "${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi",
                    hintText: "Deskripsi jadwal",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  setState(() {
                    _schedules.add({
                      "date": _dateController.text,
                      "time": _timeController.text,
                      "description": _descriptionController.text,
                    });
                  });
                  _dateController.clear();
                  _timeController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jadwal Opname Perangkat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Jadwal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading:
                          const Icon(Icons.event, color: Colors.blueAccent),
                      title: Text(schedule["description"]),
                      subtitle:
                          Text("${schedule["date"]} - ${schedule["time"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _schedules.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addScheduleDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
