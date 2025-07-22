import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/putusan_model.dart';

class PutusanController {
  Future<List<PutusanModel>> fetchPutusan() async {
    final response = await http.get(Uri.parse(
        'https://jdih-simprokum.batukota.go.id/api/produk-hukum/putusan-pengadilan?page=1&per_page=10'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['produkHukum']['data'];
      return data.map((e) => PutusanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load putusan');
    }
  }
}
