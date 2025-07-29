import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/homepage_controller.dart';
import '../models/hukum_model.dart';

class SemuaPeraturanPage extends StatefulWidget {
  const SemuaPeraturanPage({super.key});

  @override
  State<SemuaPeraturanPage> createState() => _SemuaPeraturanPageState();
}

class _SemuaPeraturanPageState extends State<SemuaPeraturanPage> {
  final controller = HomePageController();
  late Future<List<HukumModel>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = controller.fetchPeraturanTerbaru();
  }

  String _formatTanggal(String tanggalString) {
    try {
      final date = DateTime.parse(tanggalString);
      return DateFormat('dd-MM-yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggalString;
    }
  }

  Future<void> _tambahView(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/view/$id');
    try {
      await http.get(url);
    } catch (e) {
      debugPrint('Gagal tambah view: $e');
    }
  }

  Future<void> _tambahDownload(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/download/$id');
    try {
      await http.get(url);
    } catch (e) {
      debugPrint('Gagal tambah download: $e');
    }
  }

  Future<void> _bukaUrl(String url, {bool isView = false, int? id}) async {
    if (isView && id != null) {
      await _tambahView(id);
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Tidak bisa membuka URL: $url');
    }
  }

  Future<void> _downloadFile(int id, String url) async {
    await _tambahDownload(id);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Peraturan Terbaru"),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<HukumModel>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada peraturan ditemukan.'));
          }

          final dataList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              final dokumenUrl =
                  'https://jdih-simprokum.batukota.go.id/storage/lampiran_dokumen/${item.lampiranDokumen ?? ''}';
              final abstrakUrl =
                  'https://jdih-simprokum.batukota.go.id/storage/lampiran_dokumen/lampiran_abstrak/${item.lampiranAbstrak ?? ''}';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.judul,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            _formatTanggal(item.tanggal),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${item.view}'),
                          const SizedBox(width: 12),
                          const Icon(Icons.download_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${item.download}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if ((item.lampiranDokumen ?? '').isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _bukaUrl(dokumenUrl, isView: true, id: item.id),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text("Lihat Dokumen"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _downloadFile(item.id, dokumenUrl),
                              icon: const Icon(Icons.download_rounded),
                              tooltip: 'Download Dokumen',
                            )
                          ],
                        ),
                      if ((item.lampiranAbstrak ?? '').isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _bukaUrl(abstrakUrl, isView: true, id: item.id),
                                icon: const Icon(Icons.description),
                                label: const Text("Lihat Abstrak"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _downloadFile(item.id, abstrakUrl),
                              icon: const Icon(Icons.download_rounded),
                              tooltip: 'Download Abstrak',
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
