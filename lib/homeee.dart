import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'riwayat.dart';
import 'tambah.dart';
import 'profil.dart';

class Homeee extends StatefulWidget {
  @override
  _HomeeeState createState() => _HomeeeState();
}

class _HomeeeState extends State<Homeee> {
  int _currentIndex = 0;

  int saldo = 0;
  int target = 1000000;
final TextEditingController targetController = TextEditingController();
  List<String> riwayat = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ✅ LOAD DATA
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      saldo = prefs.getInt('saldo') ?? 0;
      riwayat = prefs.getStringList('riwayat') ?? [];
      target = prefs.getInt('target') ?? 1000000;
    });
  }

  // ✅ SAVE DATA
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('saldo', saldo);
    await prefs.setStringList('riwayat', riwayat);
    await prefs.setInt('target', target);
  }

  // ✅ TAMBAH SALDO
  void tambahSaldo(int jumlah) {
    String tanggal =
        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    setState(() {
      saldo += jumlah;
      riwayat.add("Masuk|Rp $jumlah|$tanggal");
    });

    saveData();
  }

  // ✅ AMBIL SALDO
  void ambilSaldo(int jumlah) {
    if (jumlah <= saldo) {
      String tanggal =
          DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

      setState(() {
        saldo -= jumlah;
        riwayat.add("Keluar|Rp $jumlah|$tanggal");
      });

      saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [

      // ===== HOME =====
      SingleChildScrollView(
        child: Column(
          children: [

            // HEADER SALDO
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1565C0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Text("Saldo Kamu", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 10),
                  Text(
                    "Rp $saldo",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: target == 0 ? 0 : (saldo / target).clamp(0.0, 1.0),
                    backgroundColor: Colors.white30,
                    color: Colors.greenAccent,
                  ),

                  SizedBox(height: 5),
                  Text(
                    "Target: Rp $target",
                      style: TextStyle(color: Colors.white70)
                      ),

SizedBox(height: 10),

ElevatedButton.icon(
  onPressed: () {
    targetController.text = target.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ubah Target"),
          content: TextField(
            controller: targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Masukkan target baru",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  target =
                      int.tryParse(targetController.text) ?? target;
                });

                saveData();

                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  },

  icon: Icon(Icons.edit),
  label: Text("Ubah Target"),
),
                ],
              ),
            ),

            SizedBox(height: 20),

            // MENU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: Text("Tambah"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {  
                      _currentIndex = 1;
                    });
                  },
                  child: Text("Riwayat"),
                ),
              ],
            ),

            SizedBox(height: 20),

            // NOTIFIKASI
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Notifikasi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.blue),
                      title: Text("Gaji Masuk"),
                      subtitle: Text("Rp 2.000.000 telah masuk"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.orange),
                      title: Text("Pengeluaran"),
                      subtitle: Text("Kamu mengeluarkan Rp 50.000"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ===== RIWAYAT =====
      Riwayat(riwayat: riwayat),

      // ===== TAMBAH =====
      TambahPage(
        onTambah: tambahSaldo,
        onAmbil: ambilSaldo,
      ),

      // ===== PROFIL =====
      Profil(target: target),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("TabunganKu"),
        backgroundColor: Color(0xFF1565C0),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Tambah"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}