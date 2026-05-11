import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  final List<String> riwayat;

  const Riwayat({super.key, required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: riwayat.length,
      itemBuilder: (context, index) {
        String item = riwayat[index];

        bool isMasuk = item.contains("Masuk");

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(
              isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
              color: isMasuk ? Colors.green : Colors.red,
            ),

            // 🔥 JUDUL (Masuk / Keluar)
            title: Text(
              isMasuk ? "Uang Masuk" : "Uang Keluar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            // 🔥 SUBTITLE (Nominal)
            subtitle: Text(item),

            // 🔥 NOMINAL DI KANAN
            trailing: Text(
              item.replaceAll("➕", "").replaceAll("➖", ""),
              style: TextStyle(
                color: isMasuk ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}