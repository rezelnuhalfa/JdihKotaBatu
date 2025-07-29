// search_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jdih_kota_batu/views/hasil_pencarian_page.dart';
import 'package:jdih_kota_batu/widgets/footer_navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final keywordController = TextEditingController();
  final nomorController = TextEditingController();
  final tahunController = TextEditingController();

  String? selectedJenisDokumen;
  String? selectedBentukPeraturan;

  bool isLoading = false;

  @override
  void dispose() {
    keywordController.dispose();
    nomorController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  String normalize(String s) => s.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  Future<void> _search() async {
    final rawKeyword = keywordController.text.trim();
    final nomor = nomorController.text.trim();
    final tahun = tahunController.text.trim();
    final normalizedKeyword = normalize(rawKeyword);

    if (normalizedKeyword.isEmpty &&
        selectedJenisDokumen == null &&
        selectedBentukPeraturan == null &&
        nomor.isEmpty &&
        tahun.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi minimal satu filter pencarian")),
      );
      return;
    }

    setState(() => isLoading = true);

    final params = {
      if (rawKeyword.isNotEmpty) 'keyword': rawKeyword,
      if (selectedJenisDokumen != null) 'jenis': selectedJenisDokumen!,
      if (selectedBentukPeraturan != null) 'bentuk': selectedBentukPeraturan!,
      if (nomor.isNotEmpty) 'nomor': nomor,
      if (tahun.isNotEmpty) 'tahun': tahun,
    };

    try {
      final uri =
          Uri.https('jdih-simprokum.batukota.go.id', '/api/simprokum', params);
      print('>> GET $uri');

      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        throw Exception('Status ${resp.statusCode}');
      }

      final data = json.decode(resp.body);
      final draft = data['draft'];
      final rawList = draft != null ? draft['data'] : null;

      if (rawList == null || rawList is! List) {
        throw Exception('Format data tidak valid');
      }

      final filtered = rawList.where((item) {
        final judul = normalize(item['judul'] ?? '');
        final nomorItem = item['nomor']?.toString().trim() ?? '';
        final tahunItem = item['tahun']?.toString().trim() ?? '';

        final matchKeyword =
            normalizedKeyword.isEmpty || judul.contains(normalizedKeyword);
        final matchNomor = nomor.isEmpty || nomorItem == nomor;
        final matchTahun = tahun.isEmpty || tahunItem == tahun;

        return matchKeyword && matchNomor && matchTahun;
      }).toList();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HasilPencarianPage(hasil: filtered),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat fetch: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _resetFilters() {
    setState(() {
      keywordController.clear();
      nomorController.clear();
      tahunController.clear();
      selectedJenisDokumen = null;
      selectedBentukPeraturan = null;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    const jenisOptions = ['Peraturan', 'Keputusan', 'Instruksi'];
    const bentukOptions = ['Perda', 'Perwali', 'SE'];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0C2D48),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PENCARIAN\nPRODUK HUKUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset("assets/images/logo_batu.png", width: 60),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildTextField(keywordController, 'KATA KUNCI'),
                const SizedBox(height: 12),
                _buildDropdown(
                    jenisOptions, selectedJenisDokumen, 'JENIS DOKUMEN', (v) {
                  setState(() => selectedJenisDokumen = v);
                }),
                const SizedBox(height: 12),
                _buildDropdown(
                    bentukOptions, selectedBentukPeraturan, 'BENTUK PERATURAN',
                    (v) {
                  setState(() => selectedBentukPeraturan = v);
                }),
                const SizedBox(height: 12),
                _buildTextField(nomorController, 'NOMOR'),
                const SizedBox(height: 12),
                _buildTextField(tahunController, 'TAHUN'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _search,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('CARI',selectionColor: Color.fromARGB(0, 255, 255, 255),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _resetFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterNavbar(currentIndex: 2),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label) => TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
        ),
      );

  Widget _buildDropdown(List<String> items, String? value, String hint,
          void Function(String?) onChanged) =>
      DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      );
}
