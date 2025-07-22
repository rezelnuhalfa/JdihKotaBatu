import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/DetailProdukHukumModel.dart';

class DetailProdukPage extends StatelessWidget {
  final DetailProdukHukumModel produk;

  const DetailProdukPage({super.key, required this.produk});

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff0f2e3c);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 72,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Produk hukum\nKOTA BATU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset("assets/images/logo_batu.png", width: 48),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.judul,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 16),

                _buildInfoRow("Nomor & Tahun", "${produk.nomorPeraturan} / ${produk.tahun}"),
                _buildInfoRow("Pemrakarsa", produk.pemrakarsa),
                _buildInfoRow("Tempat Penetapan", produk.tempatPenetapan),
                _buildInfoRow("Tanggal Penetapan", produk.tanggalPenetapan),
                _buildInfoRow("Penandatangan", produk.penandatangan),
                _buildInfoRow("Status", produk.status),
                const Divider(height: 32),

                _buildInfoRow("Subjek", produk.subjek),
                _buildInfoRow("Sumber", produk.sumber),
                _buildInfoRow("Lokasi", produk.lokasi),
                _buildInfoRow("Bidang Hukum", produk.bidangHukum),
                _buildInfoRow("Urusan Pemerintahan", produk.urusanPemerintahan),
                const Divider(height: 32),

                if ((produk.lampiranDokumen.isNotEmpty) || (produk.lampiranAbstrak.isNotEmpty))
                  Row(
                    children: [
                      if (produk.lampiranDokumen.isNotEmpty)
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            onPressed: () => _launchURL(context, produk.lampiranDokumen),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("Lihat Dokumen"),
                          ),
                        ),
                      if (produk.lampiranDokumen.isNotEmpty && produk.lampiranAbstrak.isNotEmpty)
                        const SizedBox(width: 12),
                      if (produk.lampiranAbstrak.isNotEmpty)
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            onPressed: () => _launchURL(context, produk.lampiranAbstrak),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("Lihat Abstrak"),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.visibility, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Dilihat: ${produk.jumlahDilihat}x"),
                    const SizedBox(width: 16),
                    const Icon(Icons.download, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Diunduh: ${produk.jumlahDiunduh}x"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
