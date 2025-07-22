class PeraturanModel {
  final int id;
  final String judul;
  final String? nomorPeraturan;
  final String? tahun;
  final String? pemrakarsa;
  final String? lampiranDokumen;

  PeraturanModel({
    required this.id,
    required this.judul,
    this.nomorPeraturan,
    this.tahun,
    this.pemrakarsa,
    this.lampiranDokumen,
  });

  factory PeraturanModel.fromJson(Map<String, dynamic> json) {
    return PeraturanModel(
      id: json['id'],
      judul: json['judul'] ?? '-',
      nomorPeraturan: json['nomor_peraturan'],
      tahun: json['tahun'],
      pemrakarsa: json['pemrakarsa'],
      lampiranDokumen: json['lampiran_dokumen'],
    );
  }
}
