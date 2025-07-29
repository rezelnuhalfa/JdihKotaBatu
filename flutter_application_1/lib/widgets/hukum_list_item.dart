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
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.picture_as_pdf, color: Colors.white),
      ),
      title: Text(
        data.judul,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.pemrakarsa),
          const SizedBox(height: 2),
          Text(
            data.tanggal,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      isThreeLine: true,
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
