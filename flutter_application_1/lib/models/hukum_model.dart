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
  final String status;
  final String? lampiranDokumen;
  final String? lampiranAbstrak; 
  final int? viewCount;
  final int? downloadCount;
  final String? file;

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
    required this.status,
    this.lampiranDokumen,
    this.lampiranAbstrak, 
    this.viewCount,
    this.downloadCount,
    this.file,
  });

  factory HukumModel.fromJson(Map<String, dynamic> json) {
    return HukumModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      kategori: json['id_jenis']?.toString() ?? '-',
      tanggal: json['tanggal_penetapan'] ?? '-',
      nomorPeraturan: json['nomor_peraturan'] ?? '-',
      tahun: json['tahun'] ?? '-',
      tempatPenetapan: json['tempat_penetapan'] ?? '-',
      bidangHukum: json['bidang_hukum'] ?? '-',
      subjek: json['subjek'] ?? '-',
      pemrakarsa: json['pemrakarsa'] ?? '-',
      status: json['id_status']?.toString() ?? '-',
      lampiranDokumen: json['lampiran_dokumen'],
      lampiranAbstrak: json['lampiran_abstrak'], 
      viewCount: json['jumlah_dilihat'] ?? 0,
      downloadCount: json['jumlah_diunduh'] ?? 0,
      file: json['lampiran_dokumen'],
    );
  }

  String get tentang => judul;
  int get view => viewCount ?? 0;
  int get download => downloadCount ?? 0;

  HukumModel copyWith({
    int? id,
    String? judul,
    String? kategori,
    String? tanggal,
    String? nomorPeraturan,
    String? tahun,
    String? tempatPenetapan,
    String? bidangHukum,
    String? subjek,
    String? pemrakarsa,
    String? status,
    String? lampiranDokumen,
    String? lampiranAbstrak,
    int? viewCount,
    int? downloadCount,
    String? file,
  }) {
    return HukumModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
      nomorPeraturan: nomorPeraturan ?? this.nomorPeraturan,
      tahun: tahun ?? this.tahun,
      tempatPenetapan: tempatPenetapan ?? this.tempatPenetapan,
      bidangHukum: bidangHukum ?? this.bidangHukum,
      subjek: subjek ?? this.subjek,
      pemrakarsa: pemrakarsa ?? this.pemrakarsa,
      status: status ?? this.status,
      lampiranDokumen: lampiranDokumen ?? this.lampiranDokumen,
      lampiranAbstrak: lampiranAbstrak ?? this.lampiranAbstrak, 
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
      file: file ?? this.file,
    );
  }
}
