import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_statistik.dart';

class StatistikController {
  Future<List<StatistikModel>> fetchStatistik() async {
    final response = await http.get(
        Uri.parse('https://jdih-simprokum.batukota.go.id/api/statistik'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['statistik'] as List;
      return data.map((json) => StatistikModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statistik');
    }
  }
}