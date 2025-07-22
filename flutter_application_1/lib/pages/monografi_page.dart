import 'package:flutter/material.dart';
import '../controllers/homepage_controller.dart';
import '../models/hukum_model.dart';
import '../widgets/hukum_list_item.dart';

class MonografiPage extends StatefulWidget {
  const MonografiPage({super.key});

  @override
  State<MonografiPage> createState() => _MonografiPageState();
}

class _MonografiPageState extends State<MonografiPage> {
  final controller = HomePageController();
  late Future<List<HukumModel>> _futureMonografi;

  @override
  void initState() {
    super.initState();
    _futureMonografi = controller.fetchMonografiHukum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
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
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Monografi Hukum\nKOTA BATU",
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

          // Body content
          Expanded(
            child: FutureBuilder<List<HukumModel>>(
              future: _futureMonografi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data tersedia.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return HukumListItem(data: snapshot.data![index]);
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
