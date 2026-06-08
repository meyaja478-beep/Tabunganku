import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'riwayat.dart';
import 'tambah.dart';
import 'profil.dart';

class Homeee extends StatefulWidget {
  const Homeee({super.key});

  @override
  State<Homeee> createState() => _HomeeeState();
}

class _HomeeeState extends State<Homeee> {

  final supabase = Supabase.instance.client;

  int _currentIndex = 0;

  int saldo = 0;
  int target = 1000000;

  final TextEditingController targetController =
      TextEditingController();

  List<String> riwayat = [];

  // ================= GET TABUNGAN ID =================
  Future<int?> _getTabunganId() async {

    final data = await supabase
        .from('tabungan')
        .select('id')
        .limit(1);

    if (data.isEmpty) {
      return null;
    }

    return data[0]['id'];
  }

  // ================= FETCH RIWAYAT =================
  Future<List<String>> _fetchRiwayat(int rowId) async {

    final data = await supabase
        .from('riwayat')
        .select()
        .eq('tabungan_id', rowId)
        .order('id', ascending: false);

    return (data as List).map((item) {

      String jenis = item['jenis'];
      int jumlah = item['jumlah'];
      String tanggal = item['tanggal'];
      String keterangan = item['keterangan'];
      return "$jenis | Rp $jumlah | $tanggal | $keterangan";

    }).toList();
  }

  // ================= TOTAL PENGELUARAN =================
  int get totalPengeluaran {

    int total = 0;

    for (var item in riwayat) {

      List<String> data = item.split('|');

      if (data[0].trim() == "Keluar") {

        total += int.tryParse(
              data[1]
                  .replaceAll("Rp", "")
                  .trim(),
            ) ??
            0;
      }
    }

    return total;
  }

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ================= LOAD DATA =================
  Future<void> loadData() async {

    final data = await supabase
        .from('tabungan')
        .select()
        .limit(1);

    int? rowId;

    if (data.isEmpty) {

      final inserted = await supabase
          .from('tabungan')
          .insert({
            'saldo': 0,
            'target': target,
          })
          .select()
          .single();

      rowId = inserted['id'];

      saldo = inserted['saldo'];
      target = inserted['target'];

    } else {

      rowId = data[0]['id'];

      saldo = data[0]['saldo'];
      target = data[0]['target'];
    }

    if (rowId != null) {

      riwayat = await _fetchRiwayat(rowId);
    }

    setState(() {});
  }

  // ================= SAVE DATA =================
  Future<void> saveData() async {

    final id = await _getTabunganId();

    if (id == null) return;

    await supabase
        .from('tabungan')
        .update({
          'saldo': saldo,
          'target': target,
        })
        .eq('id', id);
  }

  // ================= TAMBAH SALDO =================
  void tambahSaldo(int jumlah, String keterangan) async {

    String tanggal =
        DateFormat('dd MMM yyyy, HH:mm')
            .format(DateTime.now());

    try {

      int? rowId = await _getTabunganId();

      // UPDATE TABUNGAN
      if (rowId == null) {

        final inserted = await supabase
            .from('tabungan')
            .insert({
              'saldo': saldo + jumlah,
              'target': target,
            })
            .select()
            .single();

        rowId = inserted['id'];

      } else {

        await supabase
            .from('tabungan')
            .update({
              'saldo': saldo + jumlah,
              'target': target,
            })
            .eq('id', rowId);
      }

      // INSERT RIWAYAT
      await supabase
          .from('riwayat')
          .insert({

        'jenis': 'Masuk',
        'jumlah': jumlah,
        'tanggal': tanggal,
        'keterangan': keterangan,
        'tabungan_id': rowId,

      });

      print("BERHASIL INSERT RIWAYAT");

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Berhasil menambahkan Rp $jumlah"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {

      print("ERROR INSERT: $e");
    }
  }

  // ================= AMBIL SALDO =================
  void ambilSaldo(int jumlah, String keterangan) async {

    if (jumlah > saldo) return;

    String tanggal =
        DateFormat('dd MMM yyyy, HH:mm')
            .format(DateTime.now());

    try {

      int? rowId = await _getTabunganId();

      if (rowId == null) return;

      // UPDATE TABUNGAN
      await supabase
          .from('tabungan')
          .update({
            'saldo': saldo - jumlah,
            'target': target,
          })
          .eq('id', rowId);

      // INSERT RIWAYAT
      await supabase
          .from('riwayat')
          .insert({

        'jenis': 'Keluar',
        'jumlah': jumlah,
        'keterangan': keterangan,
        'tanggal': tanggal,
        'tabungan_id': rowId,

      });

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Berhasil mengambil Rp $jumlah"),
          backgroundColor: Colors.orange,
        ),
      );

    } catch (e) {

      print("ERROR AMBIL: $e");
    }
  }
int get totalPemasukan {

  int total = 0;

  for (var item in riwayat) {

    List<String> data = item.split('|');

    if (data[0].trim() == "Masuk") {

      total += int.tryParse(
            data[1]
                .replaceAll("Rp", "")
                .trim(),
          ) ??
          0;
    }
  }

  return total;
}

int get totalTransaksi => riwayat.length;

String get pengeluaranTerbesar {

  int terbesar = 0;
  String ket = "-";

  for (var item in riwayat) {

    List<String> data = item.split('|');

    if (data[0].trim() == "Keluar") {

      int nominal = int.tryParse(
            data[1]
                .replaceAll("Rp", "")
                .trim(),
          ) ??
          0;

      if (nominal > terbesar) {

        terbesar = nominal;

        ket = data.length > 3
            ? data[3].trim()
            : "-";
      }
    }
  }

  return "$ket (Rp $terbesar)";
}
  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [

     // ================= HOME =================
SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [

      // KARTU SALDO
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [

            const Text(
              "Total Saldo",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Rp $saldo",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                Expanded(
                  child: LinearProgressIndicator(
                    value: target == 0
                        ? 0
                        : (saldo / target)
                            .clamp(0.0, 1.0),
                    minHeight: 12,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  "${((saldo / target) * 100).clamp(0, 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              "Target: Rp $target",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {

                targetController.text =
                    target.toString();

                showDialog(
                  context: context,
                  builder: (context) {

                    return AlertDialog(
                      title:
                          const Text("Ubah Target"),

                      content: TextField(
                        controller:
                            targetController,
                        keyboardType:
                            TextInputType.number,
                      ),

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          child:
                              const Text("Batal"),
                        ),

                        ElevatedButton(
                          onPressed: () async {

                            target =
                                int.tryParse(
                                      targetController
                                          .text,
                                    ) ??
                                    target;

                            await saveData();

                            setState(() {});

                            Navigator.pop(
                                context);
                          },
                          child:
                              const Text("Simpan"),
                        ),
                      ],
                    );
                  },
                );
              },

              icon: const Icon(Icons.edit),

              label: const Text(
                "Ubah Target",
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // PEMASUKAN & PENGELUARAN
      Row(
        children: [

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  CircleAvatar(
                    backgroundColor:
                        Colors.white,
                    radius: 28,
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Uang Masuk",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Rp $totalPemasukan",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  CircleAvatar(
                    backgroundColor:
                        Colors.white,
                    radius: 28,
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Uang Keluar",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Rp $totalPengeluaran",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      // RINGKASAN BULAN INI
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ringkasan Bulan Ini",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                leading:
                    const Icon(Icons.receipt),
                title: const Text(
                    "Total Transaksi"),
                trailing:
                    Text("$totalTransaksi"),
              ),

              ListTile(
                leading:
                    const Icon(Icons.warning),
                title: const Text(
                    "Pengeluaran Terbesar"),
                trailing: Expanded(
                  child: Text(
                    pengeluaranTerbesar,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),

      // TRANSAKSI TERAKHIR
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transaksi Terakhir",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              if (riwayat.isEmpty)
                const Text(
                  "Belum ada transaksi",
                ),

              for (int i = 0;
                  i <
                      (riwayat.length > 3
                          ? 3
                          : riwayat.length);
                  i++)

                ListTile(
                  leading: Icon(
                    riwayat[i]
                            .contains(
                                "Masuk")
                        ? Icons
                            .arrow_upward
                        : Icons
                            .arrow_downward,
                    color: riwayat[i]
                            .contains(
                                "Masuk")
                        ? Colors.green
                        : Colors.red,
                  ),

                  title: Text(
                    riwayat[i],
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  ),
),
      // ================= RIWAYAT =================
      Riwayat(riwayat: riwayat),

      // ================= TAMBAH =================
      TambahPage(
        onTambah: tambahSaldo,
        onAmbil: ambilSaldo,
      ),

      // ================= PROFIL =================
      Profil(target: target),
    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text("TabunganKu"),
        backgroundColor:
            const Color(0xFF1565C0),
      ),

      body: pages[_currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Riwayat",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Tambah",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}