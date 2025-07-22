import 'package:flutter/material.dart';
import 'package:jdih_kota_batu/views/peraturan_page.dart';
import 'package:jdih_kota_batu/views/semua_peraturan_page.dart';
import 'package:jdih_kota_batu/views/artikel_page.dart';
import 'package:jdih_kota_batu/pages/monografi_page.dart';
import 'package:jdih_kota_batu/pages/putusan_pages.dart';
import '../widgets/fitur_menu_widget.dart';
import '../widgets/footer_navbar.dart';
import '../widgets/hukum_list_item.dart';
import '../controllers/homepage_controller.dart';
import '../models/hukum_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController controller = HomePageController();
  late Future<List<HukumModel>> _futurePeraturanTerbaru;

  @override
  void initState() {
    super.initState();
    _futurePeraturanTerbaru = controller.fetchPeraturanTerbaru();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),

            // Header Logo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff0f2e3c),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'JDIH\nKOTA BATU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFFFC107)),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Image.asset("assets/images/logo_batu.png", width: 60),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Ikon (Fitur)
            FiturMenuWidget(
              onTapPeraturan: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PeraturanPage()));
              },
              onTapArtikel: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ArtikelPage()));
              },
              onTapMonografi: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MonografiPage()));
              },
              onTapPutusan: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PutusanPage()));
              },
            ),

            const SizedBox(height: 24),

            // Header Peraturan Terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Peraturan Terbaru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SemuaPeraturanPage()),
                    );
                  },
                  child:
                      const Text('Selengkapnya', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // FutureBuilder Peraturan Terbaru
            FutureBuilder<List<HukumModel>>(
              future: _futurePeraturanTerbaru,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Terjadi kesalahan: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Tidak ada peraturan terbaru.');
                }

                final list = snapshot.data!;
                final limitedList =
                    list.length > 3 ? list.sublist(0, 3) : list;

                return Column(
                  children:
                      limitedList.map((item) => HukumListItem(data: item)).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavbar(currentIndex: 0),
    );
  }
}
