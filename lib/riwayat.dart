import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  final List<String> riwayat;

  const Riwayat({
    super.key,
    required this.riwayat,
  });

  @override
  Widget build(BuildContext context) {
    if (riwayat.isEmpty) {
      return const Center(
        child: Text("Belum ada riwayat"),
      );
    }

    return ListView.builder(
      itemCount: riwayat.length,
      itemBuilder: (context, index) {
        String item = riwayat[index];

        List<String> data = item.split('|');

        String jenis = data.length > 0 ? data[0].trim() : '';
        String nominal = data.length > 1 ? data[1].trim() : '';
        String keterangan = data.length > 2 ? data[2].trim() : '-';
        String tanggal = data.length > 3 ? data[3].trim() : '';

        bool isMasuk = jenis == "Masuk";

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: ListTile(
            leading: Icon(
              isMasuk
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: isMasuk
                  ? Colors.green
                  : Colors.red,
            ),

            title: Text(
              keterangan,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jenis),
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            trailing: Text(
              nominal,
              style: TextStyle(
                color: isMasuk
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}