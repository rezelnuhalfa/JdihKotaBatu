import 'package:flutter/material.dart';
import 'package:jdih_kota_batu/views/profile/dasar_hukum_page.dart';
import 'package:jdih_kota_batu/views/profile/struktur_organisasi_page.dart';
import 'package:jdih_kota_batu/widgets/footer_navbar.dart';
import 'pengantar_page.dart';
import 'kontak_page.dart';
import 'faq_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.description, 'title': 'Pengantar'},
      {'icon': Icons.phone, 'title': 'Kontak'},
      {'icon': Icons.help_outline, 'title': 'FAQ'},
      {'icon': Icons.gavel, 'title': 'Dasar Hukum'},
      {'icon': Icons.groups, 'title': 'Struktur Organisasi'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔷 Header
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
                  const Text(
                    "PROFIL JDIH\nKOTA BATU",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Image.asset("assets/images/logo_batu.png", width: 60),
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.black87),
                    title: Text(item['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (item['title'] == 'Pengantar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PengantarPage(),
                          ),
                        );
                      } else if (item['title'] == 'Kontak') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KontakPage(),
                          ),
                        );
                      } else if (item['title'] == 'FAQ') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FAQPage(),
                          ),
                        );
                      } else if (item['title'] == 'Struktur Organisasi') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StrukturOrganisasiPage(),
                          ),
                        );
                      } else if (item['title'] == 'Dasar Hukum') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DasarHukumPage(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    
      bottomNavigationBar: const FooterNavbar(currentIndex: 3),
    );
  }
}
