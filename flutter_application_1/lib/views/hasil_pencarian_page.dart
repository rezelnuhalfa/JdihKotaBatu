import 'package:flutter/material.dart';
import 'package:jdih_kota_batu/models/DetailProdukHukumModel.dart';
import 'package:jdih_kota_batu/pages/DetailProdukPage.dart';

class HasilPencarianPage extends StatelessWidget {
  final List<dynamic> hasil;

  const HasilPencarianPage({super.key, required this.hasil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // Custom AppBar
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    "Hasil Pencarian",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset("assets/images/logo_batu.png", width: 60),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Body
          Expanded(
            child: hasil.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data ditemukan",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: hasil.length,
                    itemBuilder: (context, index) {
                      final item = hasil[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(
                            item['judul'] ?? 'Tanpa Judul',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("Nomor: ${item['nomor_peraturan'] ?? '-'}"),
                              Text("Tahun: ${item['tahun'] ?? '-'}"),
                              if (item['jenis'] != null)
                                Text("Jenis: ${item['jenis']}"),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            final detail =
                                DetailProdukHukumModel.fromJson(item);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailProdukPage(produk: detail),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
