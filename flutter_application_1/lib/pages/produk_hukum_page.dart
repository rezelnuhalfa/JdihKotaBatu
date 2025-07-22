import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jdih_kota_batu/pages/DetailProdukPage.dart';
import 'dart:convert';

import '../widgets/footer_navbar.dart';
import '../models/DetailProdukHukumModel.dart';
import '../pages/DetailProdukPage.dart';

class ProdukHukumPage extends StatefulWidget {
  const ProdukHukumPage({super.key});

  @override
  State<ProdukHukumPage> createState() => _ProdukHukumPageState();
}

class _ProdukHukumPageState extends State<ProdukHukumPage> {
  int currentPage = 1;
  final int perPage = 10;
  bool isLoading = false;
  bool isEnd = false;
  List<dynamic> produkList = [];

  @override
  void initState() {
    super.initState();
    fetchProdukHukum();
  }

  Future<void> fetchProdukHukum() async {
    if (isLoading || isEnd) return;

    setState(() => isLoading = true);
    final url =
        'https://jdih-simprokum.batukota.go.id/api/simprokum?page=$currentPage&per_page=$perPage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final draftData = jsonData['draft']?['data'] ?? [];
        final ditetapkanData = jsonData['ditetapkan']?['data'] ?? [];
        final diundangkanData = jsonData['diundangkan']?['data'] ?? [];

        final allData = [...draftData, ...ditetapkanData, ...diundangkanData];

        setState(() {
          if (allData.isEmpty) {
            isEnd = true;
          } else {
            currentPage++;
            produkList.addAll(allData);
          }
        });
      } else {
        throw Exception('Gagal mengambil data produk hukum');
      }
    } catch (e) {
      debugPrint('Error saat fetch produk: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildItem(dynamic item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          item['judul'] ?? 'Tanpa Judul',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['nomor_peraturan'] != null)
              Text(
                item['nomor_peraturan'],
                style: const TextStyle(fontSize: 14),
              ),
            if (item['tanggal_pengundangan'] != null)
              Text(
                'Tanggal: ${item['tanggal_pengundangan']}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          final detail = DetailProdukHukumModel.fromJson(item);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProdukPage(produk: detail)
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Column(
        children: [
          // Header
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "List Produk Hukum\nKOTA BATU",
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

          // ListView Produk Hukum
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  fetchProdukHukum();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: produkList.length + 1,
                itemBuilder: (context, index) {
                  if (index < produkList.length) {
                    return buildItem(produkList[index]);
                  } else {
                    return isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterNavbar(currentIndex: 1),
    );
  }
}
