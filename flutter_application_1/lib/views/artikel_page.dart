import 'package:flutter/material.dart';
import '../models/hukum_model.dart';
import '../controllers/homepage_controller.dart';
import '../widgets/hukum_list_item.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final controller = HomePageController();
  late Future<List<HukumModel>> _futureArtikel;

  @override
  void initState() {
    super.initState();
    _futureArtikel = controller.fetchArtikelHukum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                // Tombol Back
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),

                // Teks judul
                const Expanded(
                  child: Text(
                    "Artikel\nKOTA BATU",
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

          // Isi List Artikel Hukum
          Expanded(
            child: FutureBuilder<List<HukumModel>>(
              future: _futureArtikel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('artikel hukum belum tersedia.'));
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: snapshot.data!
                      .map((item) => HukumListItem(data: item))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
