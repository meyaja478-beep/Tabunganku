import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
     return SingleChildScrollView(
      child: Column(
        children: [
         Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF64B5F6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
             child: Column(
              children: [
                 CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF1565C0),
                  ),
                ),

                SizedBox(height: 15),
Text(
                  "Mey aja",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),
 Text(
                  "meyaja478@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.account_circle, color: Colors.blue),
                    title: Text("Status"),
                    subtitle: Text("Pengguna Aktif"),
                  ),
                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.savings, color: Colors.green),
                    title: Text("Target Tabungan"),
                    subtitle: Text("Rp 1.000.000"),
                  ),
                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.orange),
                    title: Text("Bergabung"),
                    subtitle: Text("Mei 2026"),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
      
          SizedBox(height: 10),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                  );
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}