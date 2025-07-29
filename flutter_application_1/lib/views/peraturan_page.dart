import 'package:flutter/material.dart';
import '../controllers/peraturan_controller.dart';
import '../models/hukum_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/download_util.dart';
import 'package:intl/intl.dart';
import '../utils/pdf_viewer_page.dart';

class PeraturanPage extends StatefulWidget {
  const PeraturanPage({super.key});

  @override
  State<PeraturanPage> createState() => _PeraturanPageState();
}

class _PeraturanPageState extends State<PeraturanPage> {
  final controller = PeraturanController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _pageInputController = TextEditingController();
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

  @override
  void dispose() {
    _scrollController.dispose();
    _pageInputController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final result = await controller.fetchPeraturan(page: _currentPage);
      final List<HukumModel> newData = result['data'];
      final int total = result['total'];
      final int perPage = result['perPage'];

      setState(() {
        _data.addAll(newData);
        _totalPages = (total / perPage).ceil();
        _currentPage++;
      });
    } catch (e) {
      debugPrint('Error saat mengambil data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String formatTanggal(String tanggalAsli) {
    try {
      final DateTime parsedDate = DateTime.parse(tanggalAsli);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
    } catch (e) {
      return tanggalAsli;
    }
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
            _buildInfoRow("Tanggal Penetapan", formatTanggal(item.tanggal)),
            _buildInfoRow("Tempat Penetapan", item.tempatPenetapan),
            _buildInfoRow("Bidang Hukum", item.bidangHukum),
            _buildInfoRow("Subjek", item.subjek),
            _buildInfoRow("Pemrakarsa", item.pemrakarsa),
            _buildInfoRow("Dilihat", item.view.toString()),
            _buildInfoRow("Diunduh", item.download.toString()),
            const SizedBox(height: 16),
            if ((item.lampiranDokumen ?? '').isNotEmpty ||
                (item.lampiranAbstrak ?? '').isNotEmpty)
              Column(
                children: [
                  if ((item.lampiranDokumen ?? '').isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final fullUrl =
                                    'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranDokumen}';

                                await controller.incrementView(item.id);
                                final updatedItem =
                                    item.copyWith(viewCount: item.view + 1);
                                setState(() {
                                  final index =
                                      _data.indexWhere((e) => e.id == item.id);
                                  if (index != -1) _data[index] = updatedItem;
                                });

                                if (await canLaunchUrl(Uri.parse(fullUrl))) {
                                  await launchUrl(Uri.parse(fullUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Tidak dapat membuka URL';
                                }
                              } catch (e) {
                                debugPrint('Gagal buka dokumen: $e');
                              }
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Lihat PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await controller.incrementDownload(item.id);
                                final updatedItem = item.copyWith(
                                    downloadCount: item.download + 1);
                                setState(() {
                                  final index =
                                      _data.indexWhere((e) => e.id == item.id);
                                  if (index != -1) _data[index] = updatedItem;
                                });

                                final fullUrl =
                                    'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranDokumen}';
                                await DownloadHelper.downloadAndOpenPdf(
                                    fullUrl, 'dokumen-${item.id}.pdf');
                              } catch (e) {
                                debugPrint('Gagal download: $e');
                              }
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Download'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),

                  // ===== ABSTRAK =====
                  if ((item.lampiranAbstrak ?? '').isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final abstrakUrl =
                                    'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranAbstrak}';

                                await controller.incrementView(item.id);
                                final updatedItem =
                                    item.copyWith(viewCount: item.view + 1);
                                setState(() {
                                  final index =
                                      _data.indexWhere((e) => e.id == item.id);
                                  if (index != -1) _data[index] = updatedItem;
                                });

                                if (await canLaunchUrl(Uri.parse(abstrakUrl))) {
                                  await launchUrl(Uri.parse(abstrakUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Tidak dapat membuka URL abstrak';
                                }
                              } catch (e) {
                                debugPrint('Gagal buka abstrak: $e');
                              }
                            },
                            icon: const Icon(Icons.description),
                            label: const Text('Lihat Abstrak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await controller.incrementDownload(item.id);
                                final updatedItem = item.copyWith(
                                    downloadCount: item.download + 1);
                                setState(() {
                                  final index =
                                      _data.indexWhere((e) => e.id == item.id);
                                  if (index != -1) _data[index] = updatedItem;
                                });

                                final fullUrl =
                                    'https://jdih-simprokum.batukota.go.id/storage/${item.lampiranAbstrak}';
                                await DownloadHelper.downloadAndOpenPdf(
                                    fullUrl, 'abstrak-${item.id}.pdf');
                              } catch (e) {
                                debugPrint('Gagal download abstrak: $e');
                              }
                            },
                            icon: const Icon(Icons.download_for_offline),
                            label: const Text('Download Abstrak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
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

  Widget _buildPaginationFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 6,
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _currentPage > 2
                    ? () {
                        setState(() {
                          _currentPage = _currentPage - 2;
                          _data.clear();
                        });
                        _fetchData();
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                'Halaman ${_currentPage - 1} dari $_totalPages',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _currentPage <= _totalPages
                    ? () {
                        _fetchData();
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ke halaman:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _pageInputController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Ketik Halaman',
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final page = int.tryParse(_pageInputController.text);
                  if (page != null &&
                      page >= 1 &&
                      page <= _totalPages &&
                      page != _currentPage - 1) {
                    setState(() {
                      _currentPage = page;
                      _data.clear();
                    });
                    _fetchData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                child: const Text('Go'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  _fetchData();
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return _buildCard(_data[index]);
                },
              ),
            ),
          ),
          _buildPaginationFooter(),
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
}
