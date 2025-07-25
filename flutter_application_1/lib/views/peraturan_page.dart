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
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Peraturan Perundang-undangan\nKOTA BATU",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Image.asset("assets/images/logo_batu.png", width: 50),
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
            style: _paginationButtonStyle(),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Halaman $_currentPage / $_totalPages',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _currentPage < _totalPages ? _goToNextPage : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Berikutnya"),
            style: _paginationButtonStyle(),
          ),
        ],
      ),
    );
  }

  ButtonStyle _paginationButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      disabledBackgroundColor: Colors.grey.shade300,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCard(HukumModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
            const SizedBox(height: 14),
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
            if (item.lampiranDokumen != null &&
                item.lampiranDokumen!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url =
                        'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranDokumen}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal membuka dokumen')),
                      );
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Lihat Dokumen PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
