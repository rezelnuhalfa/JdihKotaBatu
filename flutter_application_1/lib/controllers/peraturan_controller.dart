import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hukum_model.dart';

class PeraturanController {
  Future<List<HukumModel>> fetchPeraturan() async {
    final response = await http.get(Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/peraturan-perundangan?page=1&per_page=10'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['produkHukum']['data'];
      return data.map((e) => HukumModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data peraturan');
    }
  }
}
