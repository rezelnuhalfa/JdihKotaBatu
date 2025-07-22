class ProdukHukum {
  final int id;
  final String judul;
  final String? tanggal;
  final String? pemrakarsa;
  final String? jenis;

  ProdukHukum({
    required this.id,
    required this.judul,
    this.tanggal,
    this.pemrakarsa,
    this.jenis,
  });

  factory ProdukHukum.fromJson(Map<String, dynamic> json) {
    return ProdukHukum(
      id: json['id'],
      judul: json['judul'],
      tanggal: json['tanggal_penetapan'],
      pemrakarsa: json['pemrakarsa'],
      jenis: json['id_jenis'].toString(),
    );
  }
}
