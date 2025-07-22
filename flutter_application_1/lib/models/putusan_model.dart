class PutusanModel {
  final String judul;
  final String tanggal;
  final String? abstrak;

  PutusanModel({
    required this.judul,
    required this.tanggal,
    this.abstrak,
  });

  factory PutusanModel.fromJson(Map<String, dynamic> json) {
    return PutusanModel(
      judul: json['judul'] ?? '',
      tanggal: json['tanggal_pengundangan'] ?? '',
      abstrak: json['abstrak'],
    );
  }
}
