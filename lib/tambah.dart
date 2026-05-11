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
  int inputNominal = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Masukkan Nominal",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              inputNominal = int.tryParse(value) ?? 0;
            },
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              widget.onTambah(inputNominal);
            },
            child: Text("Tambah"),
          ),

          ElevatedButton(
            onPressed: () {
              widget.onAmbil(inputNominal);
            },
            child: Text("Ambil"),
          ),
        ],
      ),
    );
  }
}