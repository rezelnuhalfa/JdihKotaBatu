import 'package:flutter/material.dart';

class PengantarPage extends StatelessWidget {
  const PengantarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengantar'),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon dekoratif di atas teks
            Column(
              children: const [
                Icon(
                  Icons.format_quote_rounded,
                  size: 60,
                  color: Color(0xff0f2e3c),
                ),
                SizedBox(height: 8),
                Text(
                  "Sambutan Kepala Bagian Hukum",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card dengan teks pengantar
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  '''Puji Syukur Kehadirat Tuhan YME atas terwujudnya JDIH Kota Batu yang sudah lama dinantikan oleh seluruh ASN Pemerintah Kota Batu dan Seluruh Masyarakat Kota Batu.

JDIH Kota Batu yang saat ini hadir ditengah layanan publik di lingkungan Pemerintah Kota Batu semoga dapat menjawab kebutuhan informasi produk hukum yang ada di Kota Batu.

Kami dari bagian hukum sedang mengupayakan untuk dapat menyediakan seluruh informasi produk hukum yang telah ditetapkan oleh Pemerintah Kota Batu berupa Perda dan Perwali. Namun untuk sementara ini, belum dapat kami penuhi secara sepenuhnya. Oleh karena itu JDIH ini tentunya masih banyak kekurangan yang harus kami perbaiki dari waktu ke waktu untuk memberikan layanan yang cepat dan mudah diakses dan tampilan yang sesuai kebutuhan masyarakat. Untuk itu mohon kritikan, saran, dan pendapat guna kesempurnaan website JDIH Kota Batu ini.

Demikian sambutan ini kami sampaikan, atas perhatian dan dukungannya kami sampaikan terima kasih.''',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
