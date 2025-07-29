import 'package:flutter/material.dart';
import 'package:jdih_kota_batu/pages/Naskah_Page.dart';
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
import '../controllers/statistik_controller.dart';
import '../models/models_statistik.dart';
import 'package:jdih_kota_batu/pages/produk_hukum_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController controller = HomePageController();
  final StatistikController statistikController = StatistikController();

  late Future<List<HukumModel>> _futurePeraturanTerbaru;
  late Future<List<StatistikModel>> _futureStatistik;

  @override
  void initState() {
    super.initState();
    _futurePeraturanTerbaru = controller.fetchPeraturanTerbaru();
    _futureStatistik = statistikController.fetchStatistik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).padding.bottom + 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProdukHukumPage()),
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color.fromRGBO(255, 193, 7, 1)),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/md-logo.png", height: 80),
                        const SizedBox(width: 10),
                        Image.asset("assets/images/logo_batu.png", height: 80),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                onTapNaskah: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const NaskahPage()));
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Statistik Produk Hukum',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<StatistikModel>>(
                future: _futureStatistik,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Gagal memuat statistik: \${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Data statistik tidak tersedia.');
                  }

                  final data = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bar_chart,
                                color: Colors.blue, size: 28),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.tipe,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '${item.jumlah} data',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Sambutan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/inge.png",
                              width: 90,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Maria Inge, S.S., S.H., M.H.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Kepala Bagian Hukum Setda Kota Batu",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Puji Syukur Kehadirat Tuhan YME atas terwujudnya JDIH Kota Batu yang sudah lama dinantikan oleh seluruh ASN Pemerintah Kota Batu dan Seluruh Masyarakat Kota Batu.\n\n'
                        'JDIH Kota Batu yang saat ini hadir ditengah layanan publik di lingkungan Pemerintah Kota Batu semoga dapat menjawab kebutuhan informasi produk hukum yang ada di Kota Batu.\n\n'
                        'Kami dari bagian hukum sedang mengupayakan untuk dapat menyediakan seluruh informasi produk hukum yang telah ditetapkan oleh Pemerintah Kota Batu berupa Perda dan Perwali. Namun untuk sementara ini, belum dapat kami penuhi secara sepenuhnya. Oleh karena itu JDIH ini tentunya masih banyak kekurangan yang harus kami perbaiki dari waktu ke waktu untuk memberikan layanan yang cepat dan mudah diakses dan tampilan yang sesuai kebutuhan masyarakat. Untuk itu mohon kritikan, saran, dan pendapat guna kesempurnaan website JDIH Kota Batu ini.\n\n'
                        'Demikian sambutan ini kami sampaikan, atas perhatian dan dukungannya kami sampaikan terima kasih.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                    child: const Text('Selengkapnya',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<HukumModel>>(
                future: _futurePeraturanTerbaru,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Terjadi kesalahan: \${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada peraturan terbaru.');
                  }

                  final list = snapshot.data!;
                  final limitedList =
                      list.length > 3 ? list.sublist(0, 3) : list;

                  return Column(
                    children: limitedList
                        .map((item) => HukumListItem(data: item))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterNavbar(currentIndex: 0),
    );
  }
}
