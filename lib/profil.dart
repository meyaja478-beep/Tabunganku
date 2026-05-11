import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text("ini_aku01",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("mayb8394@gmail.com"),
        ],
      ),
    );
  }
}