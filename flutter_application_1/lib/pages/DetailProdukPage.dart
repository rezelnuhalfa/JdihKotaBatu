import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/DetailProdukHukumModel.dart';

class DetailProdukPage extends StatefulWidget {
  final DetailProdukHukumModel produk;

  const DetailProdukPage({super.key, required this.produk});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  @override
  void initState() {
    super.initState();
    _tambahView(widget.produk.id);
  }

  Future<void> _tambahView(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/view/$id');
    try {
      await http.get(url);
    } catch (e) {
      debugPrint('Gagal menambahkan view: $e');
    }
  }

  Future<void> _tambahDownload(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/download/$id');
    try {
      await http.get(url);
    } catch (e) {
      debugPrint('Gagal menambahkan download: $e');
    }
  }

  Future<void> _launchWithView(BuildContext context, String path, int id) async {
    final url = 'https://jdih-simprokum.batukota.go.id/storage/$path';
    final uri = Uri.parse(url);

    try {
      await _tambahView(id);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Gagal membuka link.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _launchWithDownload(BuildContext context, String path, int id) async {
    final url = 'https://jdih-simprokum.batukota.go.id/storage/$path';
    final uri = Uri.parse(url);

    try {
      await _tambahDownload(id);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Gagal membuka link.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _launchAbstrakView(BuildContext context, String path, int id) async {
    final url = 'https://jdih-simprokum.batukota.go.id/storage/$path';
    final uri = Uri.parse(url);

    try {
      await _tambahView(id);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Gagal membuka abstrak.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _launchAbstrakDownload(BuildContext context, String path, int id) async {
    final url = 'https://jdih-simprokum.batukota.go.id/storage/$path';
    final uri = Uri.parse(url);

    try {
      await _tambahDownload(id);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Gagal mengunduh abstrak.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff0f2e3c);
    final produk = widget.produk;

    String tanggalFormatted = produk.tanggalPenetapan;
    try {
      final parsedDate = DateTime.parse(produk.tanggalPenetapan);
      tanggalFormatted = DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (_) {}

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
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const SizedBox(height: 16),
                _buildInfoRow("Nomor & Tahun", "${produk.nomorPeraturan} / ${produk.tahun}"),
                _buildInfoRow("Pemrakarsa", produk.pemrakarsa),
                _buildInfoRow("Tempat Penetapan", produk.tempatPenetapan),
                _buildInfoRow("Tanggal Penetapan", tanggalFormatted),
                _buildInfoRow("Penandatangan", produk.penandatangan),
                _buildInfoRow("Status", produk.status),
                const Divider(height: 32),
                _buildInfoRow("Subjek", produk.subjek),
                _buildInfoRow("Sumber", produk.sumber),
                _buildInfoRow("Lokasi", produk.lokasi),
                _buildInfoRow("Bidang Hukum", produk.bidangHukum),
                _buildInfoRow("Urusan Pemerintahan", produk.urusanPemerintahan),
                const Divider(height: 32),

                if (produk.lampiranDokumen.isNotEmpty || produk.lampiranAbstrak.isNotEmpty)
                  Column(
                    children: [
                      if (produk.lampiranDokumen.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () => _launchWithView(
                                    context, produk.lampiranDokumen, produk.id),
                                icon: const Icon(Icons.visibility),
                                label: const Text("Lihat Dokumen"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () => _launchWithDownload(
                                    context, produk.lampiranDokumen, produk.id),
                                icon: const Icon(Icons.download),
                                label: const Text("Download Dokumen"),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      if (produk.lampiranAbstrak.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () => _launchAbstrakView(
                                    context, produk.lampiranAbstrak, produk.id),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text("Lihat Abstrak"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () => _launchAbstrakDownload(
                                    context, produk.lampiranAbstrak, produk.id),
                                icon: const Icon(Icons.download),
                                label: const Text("Download Abstrak"),
                              ),
                            ),
                          ],
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
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
