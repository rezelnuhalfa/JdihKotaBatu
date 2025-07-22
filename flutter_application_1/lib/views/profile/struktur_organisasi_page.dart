import 'package:flutter/material.dart';

class StrukturOrganisasiPage extends StatelessWidget {
  const StrukturOrganisasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Struktur Organisasi"),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            'assets/images/struktur_organisasi.png', 
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
