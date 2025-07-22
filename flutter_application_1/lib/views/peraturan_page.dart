import 'package:flutter/material.dart';
import '../controllers/peraturan_controller.dart';
import '../models/hukum_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PeraturanPage extends StatefulWidget {
  const PeraturanPage({super.key});

  @override
  State<PeraturanPage> createState() => _PeraturanPageState();
}

class _PeraturanPageState extends State<PeraturanPage> {
  final controller = PeraturanController();

  final Color primaryColor = const Color(0xff0f2e3c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
         
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xff0f2e3c),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Back
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),

                // Teks judul
                const Expanded(
                  child: Text(
                    "Peraturan Perundang undangan\nKOTA BATU",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Logo
                Image.asset("assets/images/logo_batu.png", width: 60),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: FutureBuilder<List<HukumModel>>(
              future: controller.fetchPeraturan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data tersedia'));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.judul,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow("Nomor", item.nomorPeraturan),
                            _buildInfoRow("Tahun", item.tahun),
                            _buildInfoRow("Tentang", item.tentang),
                            _buildInfoRow("Status", item.status),
                            _buildInfoRow("Kategori", item.kategori),
                            _buildInfoRow("Tanggal Penetapan", item.tanggal),
                            _buildInfoRow("Tempat Penetapan", item.tempatPenetapan),
                            _buildInfoRow("Bidang Hukum", item.bidangHukum),
                            _buildInfoRow("Subjek", item.subjek),
                            _buildInfoRow("Pemrakarsa", item.pemrakarsa),
                            const SizedBox(height: 16),
                            if (item.lampiranDokumen != null &&
                                item.lampiranDokumen!.isNotEmpty)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final url =
                                        'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranDokumen}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(
                                        Uri.parse(url),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Gagal membuka dokumen'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.picture_as_pdf),
                                  label: const Text('Buka Dokumen PDF'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 94, 94, 94),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                    textStyle: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
