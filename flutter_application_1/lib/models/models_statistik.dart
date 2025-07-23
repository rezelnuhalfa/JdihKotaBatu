class StatistikModel {
  final String tipe;
  final int jumlah;

  StatistikModel({
    required this.tipe,
    required this.jumlah,
  });

  /// Factory constructor untuk membuat instance dari JSON
  factory StatistikModel.fromJson(Map<String, dynamic> json) {
    return StatistikModel(
      tipe: json['tipe'] ?? 'Tidak Diketahui',
      jumlah: json['produk_hukum_count'] ?? 0,
    );
  }

  /// Optional: method untuk mengubah model kembali ke bentuk JSON
  Map<String, dynamic> toJson() {
    return {
      'tipe': tipe,
      'produk_hukum_count': jumlah,
    };
  }
}
