import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hukum_model.dart';

class PeraturanController {
  // Ambil daftar peraturan dengan pagination
  Future<Map<String, dynamic>> fetchPeraturan({int page = 1}) async {
    final url = Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/peraturan-perundangan?page=$page&per_page=10');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['produkHukum']['data'];
      final int total = jsonBody['produkHukum']['total'];
      final int perPage = jsonBody['produkHukum']['per_page'];

      return {
        'data': data.map((e) => HukumModel.fromJson(e)).toList(),
        'total': total,
        'perPage': perPage,
      };
    } else {
      throw Exception('Gagal memuat data peraturan');
    }
  }

  // Tambah jumlah dilihat
  Future<void> incrementView(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/view/$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan view count');
    }

    final body = json.decode(response.body);
    if (body['success'] != true) {
      throw Exception('Respon API view gagal: ${body['message']}');
    }
  }

  // Tambah jumlah diunduh
  Future<void> incrementDownload(int id) async {
    final url = Uri.parse('https://jdih-simprokum.batukota.go.id/api/download/$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan download count');
    }

    final body = json.decode(response.body);
    if (body['success'] != true) {
      throw Exception('Respon API download gagal: ${body['message']}');
    }
  }
}
