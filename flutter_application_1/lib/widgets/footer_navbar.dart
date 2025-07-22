import 'package:flutter/material.dart';
import 'package:jdih_kota_batu/pages/homepage.dart';
import 'package:jdih_kota_batu/pages/produk_hukum_page.dart';
import 'package:jdih_kota_batu/views/profile/search/search_page.dart';
import 'package:jdih_kota_batu/views/profile/profile_page.dart';

class FooterNavbar extends StatelessWidget {
  final int currentIndex;

  const FooterNavbar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const HomePage();
        break;
      case 1:
        nextPage = const ProdukHukumPage();
        break;
      case 2:
        nextPage = const SearchPage();
        break;
      case 3:
        nextPage = const ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff0f2e3c),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, "Beranda", 0),
          _buildNavItem(context, Icons.library_books, "Produk", 1),
          _buildNavItem(context, Icons.search, "Cari", 2),
          _buildNavItem(context, Icons.person, "Profil", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.amberAccent : Colors.white70,
            size: 26,
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            )
        ],
      ),
    );
  }
}
