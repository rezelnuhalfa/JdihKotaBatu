import 'package:flutter/material.dart';
import '../models/hukum_model.dart';
import '../pages/detail_peraturan_page.dart';

class HukumListItem extends StatelessWidget {
  final HukumModel data;

  const HukumListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.picture_as_pdf),
      ),
      title: Text(
        data.judul,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(data.pemrakarsa),
      trailing: Text(data.tanggal),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPeraturanPage(hukum: data),
          ),
        );
      },
    );
  }
}
