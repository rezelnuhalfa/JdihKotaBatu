import 'package:flutter/material.dart';
import '../controllers/homepage_controller.dart';
import '../models/hukum_model.dart';
import '../widgets/hukum_list_item.dart';

class SemuaPeraturanPage extends StatelessWidget {
  const SemuaPeraturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomePageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Peraturan Terbaru"),
        backgroundColor: const Color(0xff0f2e3c),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<HukumModel>>(
        future: controller.fetchPeraturanTerbaru(), // ✅ Ini dipakai
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada peraturan ditemukan.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return HukumListItem(data: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
