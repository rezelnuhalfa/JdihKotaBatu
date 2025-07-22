class HukumModel {
  final int id;
  final String judul;
  final String kategori;
  final String tanggal;
  final String nomorPeraturan;
  final String tahun;
  final String tempatPenetapan;
  final String bidangHukum;
  final String subjek;
  final String pemrakarsa;
  final StatusPeraturan? statusPeraturan;
  final String? lampiranDokumen;

  HukumModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.nomorPeraturan,
    required this.tahun,
    required this.tempatPenetapan,
    required this.bidangHukum,
    required this.subjek,
    required this.pemrakarsa,
    this.statusPeraturan,
    this.lampiranDokumen,
  });

  factory HukumModel.fromJson(Map<String, dynamic> json) {
    return HukumModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      tanggal: json['tanggal_penetapan'] ?? '',
      nomorPeraturan: json['nomor_peraturan'] ?? '',
      tahun: json['tahun'] ?? '',
      tempatPenetapan: json['tempat_penetapan'] ?? '',
      bidangHukum: json['bidang_hukum'] ?? '',
      subjek: json['subjek'] ?? '',
      pemrakarsa: json['pemrakarsa'] ?? '',
      statusPeraturan: json['status_peraturan'] != null
          ? StatusPeraturan.fromJson(json['status_peraturan'])
          : null,
      lampiranDokumen: json['lampiran_dokumen'],
    );
  }

  get nomor => null;

  get tentang => null;

  get status => null;
}

class StatusPeraturan {
  final int id;
  final String status;

  StatusPeraturan({
    required this.id,
    required this.status,
  });

  factory StatusPeraturan.fromJson(Map<String, dynamic> json) {
    return StatusPeraturan(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
