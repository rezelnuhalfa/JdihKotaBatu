import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hukum_model.dart';

class PeraturanController {
  Future<Map<String, dynamic>> fetchPeraturan({int page = 1}) async {
    final response = await http.get(Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/peraturan-perundangan?page=$page&per_page=10'));

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
}
