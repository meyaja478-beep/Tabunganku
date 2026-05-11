import 'package:flutter/material.dart';

class TambahPage extends StatefulWidget {
  final Function(int) onTambah;
  final Function(int) onAmbil;

  const TambahPage({
    super.key,
    required this.onTambah,
    required this.onAmbil,
  });

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final TextEditingController nominalController = TextEditingController();
  int inputNominal = 0;

  @override
  void dispose() {
    nominalController.dispose();
    super.dispose();
  }

  void resetForm() {
    nominalController.clear();
    setState(() {
      inputNominal = 0;
    });
  }

  void tambahSaldo() {
    if (inputNominal > 0) {
      widget.onTambah(inputNominal);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil menambahkan Rp $inputNominal"),
          backgroundColor: Colors.green,
        ),
      );

      resetForm();
    }
  }

  void ambilSaldo() {
    if (inputNominal > 0) {
      widget.onAmbil(inputNominal);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil mengambil Rp $inputNominal"),
          backgroundColor: Colors.orange,
        ),
      );

      resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ===== CARD INPUT =====
          Card(
            elevation: 10,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Kelola Saldo",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Tambah atau ambil saldo tabunganmu",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Masukkan Nominal",
                      hintText: "Contoh: 50000",
                      prefixText: "Rp ",
                      prefixStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      suffixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      inputNominal = int.tryParse(value) ?? 0;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ===== TAMBAH SALDO =====
          SizedBox(
            width: double.infinity,
            height: 85,
            child: ElevatedButton(
              onPressed: tambahSaldo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: const Icon(Icons.add, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tambah Saldo",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Menambah saldo tabungan",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 35),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ===== AMBIL SALDO =====
          SizedBox(
            width: double.infinity,
            height: 85,
            child: ElevatedButton(
              onPressed: ambilSaldo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child:
                        const Icon(Icons.remove, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ambil Saldo",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mengambil saldo tabungan",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 35),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ===== RESET =====
          SizedBox(
            width: double.infinity,
            height: 80,
            child: OutlinedButton(
              onPressed: resetForm,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.refresh, color: Colors.blue),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "Kosongkan input nominal",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.blue),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===== TIPS =====
          Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.info, color: Colors.white),
              ),
              title: Text(
                "Tips",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Gunakan menu ini untuk menambah atau mengambil saldo tabungan.",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}