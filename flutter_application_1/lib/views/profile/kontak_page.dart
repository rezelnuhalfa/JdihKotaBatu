import 'package:flutter/material.dart';

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kontak"),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kontak JDIH Kota Batu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pusat informasi dan layanan publik resmi JDIH Kota Batu. Hubungi kami melalui email, telepon, atau kunjungi langsung kantor kami.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Text("Alamat:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              "Bagian Hukum Setda Kota Batu\nBlock Office Gedung A Lantai 3\nBalai Kota Among Tani\nJl. Panglima Sudirman 507 Kota Batu",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            const Text("Telp:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Kantor: (0341) 512555", style: TextStyle(fontSize: 16)),
            const Text("Admin JDIH: 0812-3306-4124 (Wahyu)", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            const Text("Email:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("hukum@batukota.go.id", style: TextStyle(fontSize: 16)),
            const Text("hukum.pemkotbatu@gmail.com", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
