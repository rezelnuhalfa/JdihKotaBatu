import 'package:flutter/material.dart';
import '../controllers/peraturan_controller.dart';
import '../models/hukum_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PeraturanPage extends StatefulWidget {
  const PeraturanPage({super.key});

  @override
  State<PeraturanPage> createState() => _PeraturanPageState();
}

class _PeraturanPageState extends State<PeraturanPage> {
  final controller = PeraturanController();
  final ScrollController _scrollController = ScrollController();

  final Color primaryColor = const Color(0xff0f2e3c);

  List<HukumModel> _data = [];
  int _currentPage = 1;
  bool _isLoading = false;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final result = await controller.fetchPeraturan(page: _currentPage);
      final List<HukumModel> newData = result['data'];
      final int total = result['total'];
      final int perPage = result['perPage'];

      setState(() {
        _data = newData;
        _totalPages = (total / perPage).ceil();
      });
    } catch (e) {
      debugPrint('Error saat mengambil data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
      _fetchData();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _buildPagination(),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return _buildCard(_data[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xff0f2e3c),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "Peraturan Perundang undangan\nKOTA BATU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Image.asset("assets/images/logo_batu.png", width: 60),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _currentPage > 1 ? _goToPreviousPage : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Sebelumnya"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0f2e3c),
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Halaman $_currentPage / $_totalPages',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _currentPage < _totalPages ? _goToNextPage : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Berikutnya"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0f2e3c),
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(HukumModel item) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.judul,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow("Nomor", item.nomorPeraturan),
            _buildInfoRow("Tahun", item.tahun),
            _buildInfoRow("Tentang", item.tentang),
            _buildInfoRow("Status", item.status),
            _buildInfoRow("Kategori", item.kategori),
            _buildInfoRow("Tanggal Penetapan", item.tanggal),
            _buildInfoRow("Tempat Penetapan", item.tempatPenetapan),
            _buildInfoRow("Bidang Hukum", item.bidangHukum),
            _buildInfoRow("Subjek", item.subjek),
            _buildInfoRow("Pemrakarsa", item.pemrakarsa),
            const SizedBox(height: 16),
            if (item.lampiranDokumen != null && item.lampiranDokumen!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url =
                        'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranDokumen}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal membuka dokumen')),
                      );
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Buka Dokumen PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 94, 94, 94),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
