import 'package:flutter/material.dart';

class FiturMenuWidget extends StatelessWidget {
  final VoidCallback onTapPeraturan;
  final VoidCallback onTapArtikel;
  final VoidCallback onTapMonografi;
  final VoidCallback onTapPutusan;

  const FiturMenuWidget({
    super.key,
    required this.onTapPeraturan,
    required this.onTapArtikel,
    required this.onTapMonografi,
    required this.onTapPutusan,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Peraturan
        GestureDetector(
          onTap: onTapPeraturan,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue,
                child: Icon(Icons.gavel, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text("Peraturan"),
            ],
          ),
        ),

        // Artikel
        GestureDetector(
          onTap: onTapArtikel,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.orange,
                child: Icon(Icons.article, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text("Artikel"),
            ],
          ),
        ),

        // Monografi
        GestureDetector(
          onTap: onTapMonografi,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green,
                child: Icon(Icons.menu_book, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text("Monografi"),
            ],
          ),
        ),

        // Putusan
        GestureDetector(
          onTap: onTapPutusan,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.purple,
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text("Putusan"),
            ],
          ),
        ),
      ],
    );
  }
}
