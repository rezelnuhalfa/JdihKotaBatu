class DetailProdukHukumModel {
  final int id; // Tambahan
  final String judul;
  final String nomorPeraturan;
  final String tahun;
  final String pemrakarsa;
  final String tempatPenetapan;
  final String tanggalPenetapan;
  final String penandatangan;
  final String status;
  final String subjek;
  final String sumber;
  final String lokasi;
  final String bidangHukum;
  final String urusanPemerintahan;
  final String lampiranDokumen;
  final String lampiranAbstrak;
  final int jumlahDilihat;
  final int jumlahDiunduh;

  DetailProdukHukumModel({
    required this.id, // Tambahkan di sini
    required this.judul,
    required this.nomorPeraturan,
    required this.tahun,
    required this.pemrakarsa,
    required this.tempatPenetapan,
    required this.tanggalPenetapan,
    required this.penandatangan,
    required this.status,
    required this.subjek,
    required this.sumber,
    required this.lokasi,
    required this.bidangHukum,
    required this.urusanPemerintahan,
    required this.lampiranDokumen,
    required this.lampiranAbstrak,
    required this.jumlahDilihat,
    required this.jumlahDiunduh,
  });

  factory DetailProdukHukumModel.fromJson(Map<String, dynamic> json) {
    return DetailProdukHukumModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      nomorPeraturan: json['nomor_peraturan'] ?? '',
      tahun: json['tahun'] ?? '',
      pemrakarsa: json['pemrakarsa'] ?? '',
      tempatPenetapan: json['tempat_penetapan'] ?? '',
      tanggalPenetapan: json['tanggal_penetapan'] ?? '',
      penandatangan: json['penandatangan'] ?? '',
      status: json['status'] ?? '',
      subjek: json['subjek'] ?? '',
      sumber: json['sumber'] ?? '',
      lokasi: json['lokasi'] ?? '',
      bidangHukum: json['bidang_hukum'] ?? '',
      urusanPemerintahan: json['urusan_pemerintahan'] ?? '',
      lampiranDokumen: json['lampiran_dokumen'] ?? '',
      lampiranAbstrak: json['lampiran_abstrak'] ?? '',
      jumlahDilihat: int.tryParse(json['jumlah_dilihat']?.toString() ?? '0') ?? 0,
      jumlahDiunduh: int.tryParse(json['jumlah_diunduh']?.toString() ?? '0') ?? 0,
    );
  }
}
