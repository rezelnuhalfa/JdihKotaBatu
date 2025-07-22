import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DasarHukumPage extends StatelessWidget {
  const DasarHukumPage({super.key});

  Future<void> _bukaLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dasarHukumList = [
      {
        'judul': 'Peraturan Presiden Republik Indonesia Nomor 33 Tahun 2012 tentang Jaringan Dokumentasi dan Informasi Hukum Nasional',
        'link': 'https://peraturan.bpk.go.id/Details/41277/perpres-no-33-tahun-2012'
      },
      {
        'judul': 'Peraturan Menteri Hukum dan HAM Nomor 8 Tahun 2019 tentang Standar Pengelolaan Dokumen dan Informasi Hukum',
        'link': 'https://peraturan.bpk.go.id/Details/133122/permenkumham-no-8-tahun-2019'
      },
      {
        'judul': 'Peraturan Wali Kota Batu Nomor 30 Tahun 2020 tentang Jaringan Dokumentasi dan Informasi Hukum Kota Batu',
        'link': 'https://simprokum.batukota.go.id/detailprokum/184'
      },
      {
        'judul': 'Keputusan Walikota Batu Nomor 52 Tahun 2024 tentang Pembentukan Tim JDIH Kota Batu',
        'link': 'https://jdih.batukota.go.id/2024/06/04/sop-jdih-kota-batu/'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dasar Hukum"),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dasarHukumList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = dasarHukumList[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['judul']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _bukaLink(item['link']!),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text("Buka Dokumen"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

