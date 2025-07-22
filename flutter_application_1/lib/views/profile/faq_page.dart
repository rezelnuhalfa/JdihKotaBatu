import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        'question': 'Apa itu Jaringan Dokumentasi dan Informasi Hukum Nasional?',
        'answer': 'JDIHN adalah wadah pendayagunaan bersama atas dokumen hukum secara tertib, terpadu, dan berkesinambungan, serta merupakan sarana pemberian layanan informasi hukum secara lengkap, akurat, mudah, dan cepat.'
      },
      {
        'question': 'Apa Tugas Pusat Jaringan Dokumentasi Dan Informasi Hukum Nasional?',
        'answer': 'Melakukan pembinaan, pengembangan, dan monitoring kepada anggota JDIHN yang meliputi organisasi, SDM, koleksi dokumen, teknis pengelolaan, sarpras, dan teknologi informasi.'
      },
      {
        'question': 'Apa Fungsi Pusat JDIHN?',
        'answer': 'Perumusan kebijakan, penyusunan standar, konsultasi, sosialisasi, pembinaan SDM, pusat rujukan, serta monitoring dan evaluasi setiap 6 bulan.'
      },
      {
        'question': 'Siapakah Anggota JDIHN?',
        'answer': 'Kementerian, Lembaga, Pemerintah Daerah, Sekretariat DPRD, Perguruan Tinggi, dan lembaga lain yang ditetapkan Menteri.'
      },
      {
        'question': 'Mengapa Anggota JDIHN Harus Memiliki Website JDIH?',
        'answer': 'Untuk mempublikasikan dokumen hukum ke masyarakat dan mempermudah integrasi dengan portal JDIHN nasional.'
      },
      {
        'question': 'Pelayanan apa saja yang disediakan JDIH Kota Batu untuk umum?',
        'answer': 'Pelayanan koleksi regulasi dan buku hukum yang dapat dibaca atau disalin oleh masyarakat.'
      },
      {
        'question': 'Apa yang dimaksud dengan Dokumen Hukum?',
        'answer': 'Produk hukum seperti peraturan perundang-undangan, putusan, yurisprudensi, artikel, buku hukum, naskah akademis, dll.'
      },
      {
        'question': 'Apa yang dimaksud dengan Peraturan Perundang-undangan?',
        'answer': 'Peraturan tertulis yang memuat norma hukum yang mengikat secara umum dan ditetapkan oleh lembaga berwenang.'
      },
      {
        'question': 'Bagaimana mencari Produk Hukum yang saya inginkan?',
        'answer': 'Masukkan kata kunci seperti judul, nomor, atau tahun peraturan pada tab pencarian, lalu klik cari.'
      },
      {
        'question': 'Mengapa file Produk Hukum tidak dapat dibuka?',
        'answer': 'Kemungkinan Anda belum menginstal aplikasi pembaca PDF seperti Adobe Reader.'
      },
      {
        'question': 'Bagaimana jika file Produk Hukum tidak tersedia di website?',
        'answer': 'Silakan hubungi kontak pengelola JDIH untuk mengajukan permohonan informasi.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions (FAQ)'),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = faqList[index];
          return ExpansionTile(
            title: Text(item['question']!, style: const TextStyle(fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(item['answer']!, style: const TextStyle(fontSize: 15)),
              )
            ],
          );
        },
      ),
    );
  }
}
