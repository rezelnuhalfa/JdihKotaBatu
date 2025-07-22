import 'package:flutter/material.dart';
import '../controllers/putusan_controller.dart';
import '../models/putusan_model.dart';

class PutusanPage extends StatefulWidget {
  const PutusanPage({super.key});

  @override
  State<PutusanPage> createState() => _PutusanPageState();
}

class _PutusanPageState extends State<PutusanPage> {
  final controller = PutusanController();
  late Future<List<PutusanModel>> _futurePutusan;

  @override
  void initState() {
    super.initState();
    _futurePutusan = controller.fetchPutusan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Putusan Pengadilan\nKOTA BATU",
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

          // Konten ListView
          Expanded(
            child: FutureBuilder<List<PutusanModel>>(
              future: _futurePutusan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada data tersedia.'));
                }

                final list = snapshot.data!;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      title: Text(item.judul),
                      subtitle: Text(item.tanggal),
                      onTap: () {
                        
                      },
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
}
