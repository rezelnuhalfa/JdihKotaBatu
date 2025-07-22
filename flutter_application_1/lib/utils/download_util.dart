import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class DownloadHelper {
  static Future<void> downloadAndOpenPdf(String url, String filename) async {
    try {
      // Dapatkan direktori penyimpanan
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$filename";

      // Download file
      final response = await Dio().download(url, filePath);
      if (response.statusCode == 200) {
        print("Download selesai: $filePath");
        OpenFile.open(filePath);
      } else {
        print("Gagal download file. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Terjadi error saat download: $e");
    }
  }
}
