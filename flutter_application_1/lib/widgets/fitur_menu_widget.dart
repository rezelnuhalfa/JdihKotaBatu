import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FiturMenuWidget extends StatelessWidget {
  final VoidCallback onTapPeraturan;
  final VoidCallback onTapArtikel;
  final VoidCallback onTapMonografi;
  final VoidCallback onTapPutusan;
  final VoidCallback onTapNaskah;

  const FiturMenuWidget({
    super.key,
    required this.onTapPeraturan,
    required this.onTapArtikel,
    required this.onTapMonografi,
    required this.onTapPutusan,
    required this.onTapNaskah,
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
                backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Peraturan",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Artikel",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Monografi",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Putusan",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Naskah
        GestureDetector(
          onTap: onTapNaskah,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                child: Icon(Icons.library_books, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Naskah",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
