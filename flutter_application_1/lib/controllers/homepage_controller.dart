import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hukum_model.dart';

class HomePageController {
  /// Mengambil data peraturan terbaru dari endpoint khusus.
  Future<List<HukumModel>> fetchPeraturanTerbaru() async {
    try {
      final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/peraturan-terbaru');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['prokum'] ?? [];

        return data.map((item) => HukumModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data peraturan terbaru: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan (peraturan terbaru): $e');
    }
  }

  /// Mengambil data peraturan perundangan untuk icon menu.
  Future<List<HukumModel>> fetchPeraturanPerundangUndangan() async {
    try {
      final url = Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/peraturan-perundangan?page=1&per_page=20',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'] ?? [];

        return data.map((item) => HukumModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data peraturan perundangan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan (perundangan): $e');
    }
  }

  /// Mengambil data artikel hukum untuk icon menu.
  Future<List<HukumModel>> fetchArtikelHukum() async {
    try {
      final url = Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/artikel-hukum',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'] ?? [];

        return data.map((item) => HukumModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data artikel hukum: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan (artikel hukum): $e');
    }
  }

  /// ✅ Mengambil data monografi hukum untuk icon menu.
  Future<List<HukumModel>> fetchMonografiHukum() async {
    try {
      final url = Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/monografi-hukum',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'] ?? [];

        return data.map((item) => HukumModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data monografi hukum: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan (monografi hukum): $e');
    }
  }
}
