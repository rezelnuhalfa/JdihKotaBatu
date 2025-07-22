import 'package:url_launcher/url_launcher.dart';

Future<void> openPdf(String relativePath) async {
  final baseUrl = 'https://jdih-simprokum.batukota.go.id/storage/';
  final Uri fullUrl = Uri.parse(baseUrl + relativePath);

  if (await canLaunchUrl(fullUrl)) {
    await launchUrl(fullUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak dapat membuka PDF: $fullUrl';
  }
}
