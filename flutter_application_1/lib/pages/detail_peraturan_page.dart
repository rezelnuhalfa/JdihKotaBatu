import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/hukum_model.dart';

class DetailPeraturanPage extends StatelessWidget {
  final HukumModel hukum;

  const DetailPeraturanPage({super.key, required this.hukum});

  Future<void> _launchPDF(String urlPath) async {
    final Uri url = Uri.parse('https://jdih-simprokum.batukota.go.id/$urlPath');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Tidak dapat membuka dokumen: $url';
    }
  }

  Widget _buildDetailCard({required IconData icon, required String title, required String? value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: const Color.fromARGB(255, 245, 245, 245),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 40, 45, 65)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(value ?? '-', style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text("Detail Peraturan"),
        backgroundColor: const Color.fromARGB(255, 40, 45, 65),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 40, 45, 65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hukum.judul ?? 'Judul tidak tersedia',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Detail cards
            _buildDetailCard(icon: Icons.confirmation_number, title: "Nomor", value: hukum.nomorPeraturan),
            _buildDetailCard(icon: Icons.date_range, title: "Tahun", value: hukum.tahun),
            _buildDetailCard(icon: Icons.description, title: "Tentang", value: hukum.tentang),
            _buildDetailCard(icon: Icons.info_outline, title: "Status", value: hukum.status),
            _buildDetailCard(icon: Icons.account_balance, title: "Kategori", value: hukum.kategori),
            _buildDetailCard(icon: Icons.calendar_today, title: "Tanggal Penetapan", value: hukum.tanggal),
            _buildDetailCard(icon: Icons.place, title: "Tempat Penetapan", value: hukum.tempatPenetapan),
            _buildDetailCard(icon: Icons.gavel, title: "Bidang Hukum", value: hukum.bidangHukum),
            _buildDetailCard(icon: Icons.subject, title: "Subjek", value: hukum.subjek),
            _buildDetailCard(icon: Icons.person, title: "Pemrakarsa", value: hukum.pemrakarsa),

            const SizedBox(height: 24),
            hukum.lampiranDokumen != null && hukum.lampiranDokumen!.isNotEmpty
                ? Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchPDF(hukum.lampiranDokumen!),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Lihat Dokumen PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 40, 45, 65),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "Lampiran tidak tersedia.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
