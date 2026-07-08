import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../dto/presensi.dart';

class PresensiDetailScreen extends StatelessWidget {
  final Presensi presensi;
  const PresensiDetailScreen({super.key, required this.presensi});

  String _formatTanggal(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} ${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Presensi')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (presensi.fotoUrl != null)
              Image.network(presensi.fotoUrl!, height: 300, fit: BoxFit.cover)
            else
              Container(
                height: 300,
                color: AppColors.inkNavy.withOpacity(0.08),
                child: const Center(child: Icon(Icons.badge_outlined, size: 64)),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(presensi.nama, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('NIM ${presensi.nim}', style: TextStyle(color: AppColors.charcoal.withOpacity(0.6))),
                  const Divider(height: 32),
                  _DetailRow(icon: Icons.access_time, label: 'Waktu', value: _formatTanggal(presensi.createdAt)),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.location_on,
                    label: 'Lokasi',
                    value: presensi.latitude != null
                        ? '${presensi.latitude!.toStringAsFixed(5)}, ${presensi.longitude!.toStringAsFixed(5)}'
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
        Icon(icon, size: 20, color: AppColors.brass),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.charcoal.withOpacity(0.5))),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}