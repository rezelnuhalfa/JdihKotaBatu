class TipeModel {
  final int id;
  final String tipe;
  final String slug;

  TipeModel({
    required this.id,
    required this.tipe,
    required this.slug,
  });

  factory TipeModel.fromJson(Map<String, dynamic> json) {
    return TipeModel(
      id: json['id'],
      tipe: json['tipe'],
      slug: json['slug'],
    );
  }
}
