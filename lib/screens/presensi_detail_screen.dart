import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../dto/presensi.dart';

class PresensiDetailScreen extends StatelessWidget {
  final Presensi presensi;
  const PresensiDetailScreen({super.key, required this.presensi});

  String _formatTanggal(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)} ${months[local.month - 1]} ${local.year} pukul ${two(local.hour)}:${two(local.minute)} WITA';
  }

  @override
  Widget build(BuildContext context) {
    final namaRaw = presensi.nama;
    String studentName = namaRaw;
    String? presenterName;
    String? presenterProdi;
    String? tanggalSeminar;

    // Parsing logic for: "Nama Mahasiswa | Presenter: Nama Presenter | Prodi: Prodi Presenter | Tanggal: Tanggal Seminar"
    if (namaRaw.contains(' | Presenter: ')) {
      final presenterParts = namaRaw.split(' | Presenter: ');
      studentName = presenterParts[0].trim();
      final rest = presenterParts[1];

      if (rest.contains(' | Prodi: ')) {
        final prodiParts = rest.split(' | Prodi: ');
        presenterName = prodiParts[0].trim();
        final rest2 = prodiParts[1];

        if (rest2.contains(' | Tanggal: ')) {
          final tanggalParts = rest2.split(' | Tanggal: ');
          presenterProdi = tanggalParts[0].trim();
          tanggalSeminar = tanggalParts[1].trim();
        } else {
          presenterProdi = rest2.trim();
        }
      } else {
        presenterName = rest.trim();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kehadiran'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo card proof
            if (presensi.fotoUrl != null)
              Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColors.inkNavy.withOpacity(0.05), width: 1.5),
                  ),
                ),
                child: Image.network(
                  presensi.fotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.broken_image_outlined, size: 64, color: AppColors.rust),
                        SizedBox(height: 12),
                        Text('Gagal memuat gambar bukti', style: TextStyle(color: AppColors.charcoal)),
                      ],
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 320,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.badge_outlined, size: 64, color: AppColors.inkNavy.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      const Text('Tidak ada gambar bukti fisik', style: TextStyle(color: AppColors.charcoal)),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Badge was removed as requested
                  
                  // Student Details
                  Text(
                    studentName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.inkNavy,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM ${presensi.nim}',
                    style: TextStyle(
                      color: AppColors.charcoal.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Divider(height: 40, color: AppColors.inkNavy.withOpacity(0.08)),

                  // Presenter Row
                  if (presenterName != null && presenterName.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.co_present_rounded,
                      label: 'Presenter Seminar',
                      value: presenterName,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Presenter Prodi Row
                  if (presenterProdi != null && presenterProdi.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.school_rounded,
                      label: 'Program Studi Presenter',
                      value: presenterProdi,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Seminar Date Row
                  if (tanggalSeminar != null && tanggalSeminar.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Tanggal Seminar',
                      value: tanggalSeminar,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Time Row
                  _DetailRow(
                    icon: Icons.access_time_filled_rounded,
                    label: 'Waktu Kehadiran',
                    value: _formatTanggal(presensi.createdAt),
                  ),
                  const SizedBox(height: 20),

                  // Location Row
                  _DetailRow(
                    icon: Icons.my_location_rounded,
                    label: 'Lokasi Demo Presensi',
                    value: presensi.latitude != null
                        ? 'Kampus Tengah Undiksha (${presensi.latitude!.toStringAsFixed(5)}, ${presensi.longitude!.toStringAsFixed(5)})'
                        : 'Tidak tercatat',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.inkNavy.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.inkNavy),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.charcoal.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}