import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import '../models/hukum_model.dart';

class DetailPeraturanPage extends StatelessWidget {
  final HukumModel hukum;

  const DetailPeraturanPage({super.key, required this.hukum});

  String _formatTanggal(String? tanggalString) {
    if (tanggalString == null || tanggalString.isEmpty) return '-';
    try {
      final date = DateTime.parse(tanggalString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggalString;
    }
  }

  Future<void> _launchPDF(String? urlPath) async {
    if (urlPath == null || urlPath.isEmpty) return;

    final Uri url = Uri.parse('https://jdih-simprokum.batukota.go.id/storage/$urlPath');

    try {
      await _tambahHitungView(hukum.id);

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Tidak dapat membuka dokumen: $url';
      }
    } catch (e) {
      debugPrint('Gagal membuka dokumen: $e');
    }
  }

  Future<void> _launchAbstrak(String? path) async {
    if (path == null || path.isEmpty) return;

    final Uri url = Uri.parse('https://jdih-simprokum.batukota.go.id/storage/$path');

    try {
      await _tambahHitungView(hukum.id); 

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Tidak dapat membuka abstrak: $url';
      }
    } catch (e) {
      debugPrint('Gagal membuka abstrak: $e');
    }
  }

  Future<void> _downloadPDF(BuildContext context, String? urlPath) async {
    await _downloadFile(context, urlPath, tambahHitung: () => _tambahHitungDownload(hukum.id));
  }

  Future<void> _downloadAbstrak(BuildContext context, String? path) async {
    await _downloadFile(context, path, tambahHitung: () => _tambahHitungDownload(hukum.id));
  }

  Future<void> _downloadFile(BuildContext context, String? urlPath, {required Future<void> Function() tambahHitung}) async {
    if (urlPath == null || urlPath.isEmpty) return;

    final url = 'https://jdih-simprokum.batukota.go.id/storage/$urlPath';
    final filename = urlPath.split('/').last;

    final status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin penyimpanan ditolak")),
      );
      return;
    }

    try {
      final dir = await getExternalStorageDirectory();
      final savePath = '${dir!.path}/$filename';

      await Dio().download(url, savePath);

      await tambahHitung(); // ✅ Tambah hitung (download view/dokumen)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil mengunduh ke $savePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh: $e')),
      );
    }
  }

  Future<void> _tambahHitungDownload(int id) async {
    final Uri apiUrl = Uri.parse('https://jdih-simprokum.batukota.go.id/api/download/$id');
    try {
      await http.get(apiUrl);
    } catch (e) {
      debugPrint('Gagal menambahkan jumlah download: $e');
    }
  }

  Future<void> _tambahHitungView(int id) async {
    final Uri apiUrl = Uri.parse('https://jdih-simprokum.batukota.go.id/api/view/$id');
    try {
      await http.get(apiUrl);
    } catch (e) {
      debugPrint('Gagal menambahkan jumlah view: $e');
    }
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String? value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF282D41)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(value ?? '-', style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool bisaDownload = hukum.lampiranDokumen != null && hukum.lampiranDokumen!.isNotEmpty;
    final bool adaAbstrak = hukum.lampiranAbstrak != null && hukum.lampiranAbstrak!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text("Detail Peraturan"),
        backgroundColor: const Color(0xFF282D41),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF282D41),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hukum.judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _buildDetailCard(icon: Icons.confirmation_number, title: "Nomor", value: hukum.nomorPeraturan),
            _buildDetailCard(icon: Icons.date_range, title: "Tahun", value: hukum.tahun),
            _buildDetailCard(icon: Icons.description, title: "Tentang", value: hukum.tentang),
            _buildDetailCard(icon: Icons.info_outline, title: "Status", value: hukum.status),
            _buildDetailCard(icon: Icons.account_balance, title: "Kategori", value: hukum.kategori),
            _buildDetailCard(icon: Icons.calendar_today, title: "Tanggal Penetapan", value: _formatTanggal(hukum.tanggal)),
            _buildDetailCard(icon: Icons.place, title: "Tempat Penetapan", value: hukum.tempatPenetapan),
            _buildDetailCard(icon: Icons.gavel, title: "Bidang Hukum", value: hukum.bidangHukum),
            _buildDetailCard(icon: Icons.subject, title: "Subjek", value: hukum.subjek),
            _buildDetailCard(icon: Icons.person, title: "Pemrakarsa", value: hukum.pemrakarsa),
            _buildDetailCard(icon: Icons.visibility, title: "Jumlah Dilihat", value: hukum.view.toString()),
            _buildDetailCard(icon: Icons.download, title: "Jumlah Diunduh", value: hukum.download.toString()),

            const SizedBox(height: 24),
            if (bisaDownload || adaAbstrak)
              Column(
                children: [
                  if (bisaDownload)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _launchPDF(hukum.lampiranDokumen),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Buka Dokumen PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _downloadPDF(context, hukum.lampiranDokumen),
                          icon: const Icon(Icons.download),
                          label: const Text("Unduh Dokumen PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  if (adaAbstrak) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _launchAbstrak(hukum.lampiranAbstrak),
                          icon: const Icon(Icons.visibility),
                          label: const Text("Lihat Abstrak"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF795548),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _downloadAbstrak(context, hukum.lampiranAbstrak),
                          icon: const Icon(Icons.download),
                          label: const Text("Unduh Abstrak"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C27B0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              )
            else
              Center(
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.block),
                  label: const Text("Dokumen Tidak Tersedia"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
