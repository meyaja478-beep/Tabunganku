import 'package:flutter/material.dart';

class TambahPage extends StatefulWidget {
  final Function(int, String) onTambah;
  final Function(int, String) onAmbil;

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
  final TextEditingController keteranganController = TextEditingController();
  int inputNominal = 0;

  @override
  void dispose() {
    nominalController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  void resetForm() {
    nominalController.clear();
    keteranganController.clear();
    setState(() {
      inputNominal = 0;
    });
  }

  void tambahSaldo() {
    if (inputNominal > 0) {
      widget.onTambah(inputNominal, keteranganController.text,);

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
      widget.onAmbil(inputNominal, keteranganController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil mengambil Rp $inputNominal"),
          backgroundColor: Colors.orange,
        ),
      );

      resetForm();
    }
  }

  bool isMasuk = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Jenis Transaksi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMasuk = true;
                    });
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: isMasuk
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isMasuk
                            ? Colors.green
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Colors.green,
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Uang Masuk",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMasuk = false;
                    });
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: !isMasuk
                          ? Colors.red.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: !isMasuk
                            ? Colors.red
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Colors.red,
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Uang Keluar",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Nominal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: nominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: "Rp ",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) {
              inputNominal =
                  int.tryParse(value) ?? 0;
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Keterangan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: keteranganController,
            decoration: InputDecoration(
              hintText:
                  "Contoh: Uang Saku, Jajan",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {

                if (isMasuk) {
                  tambahSaldo();
                } else {
                  ambilSaldo();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Simpan Transaksi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}