import 'package:flutter/material.dart';
import 'login_page.dart'; // ✅ sudah benar

void main() {
  runApp(TabunganApp());
}

class TabunganApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // ✅ sudah benar
    );
  }
}