import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubit/riwayat_cubit.dart';
import '../cubit/riwayat_state.dart';
import 'presensi_detail_screen.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  String _formatTanggal(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)} ${months[local.month - 1]} ${local.year} ${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RiwayatCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Kehadiran'),
        ),
        body: BlocBuilder<RiwayatCubit, RiwayatState>(
          builder: (context, state) {
            if (state is RiwayatLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brass),
              );
            }

            if (state is RiwayatError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.rust, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat riwayat: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.ivory),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<RiwayatCubit>().fetchRiwayat(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final list = (state as RiwayatLoaded).data;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: AppColors.charcoal.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada riwayat kehadiran',
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Silakan rekam presensi pertama Anda hari ini.',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.brass,
              backgroundColor: AppColors.navySurface,
              onRefresh: () => context.read<RiwayatCubit>().fetchRiwayat(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];

                  // Splitting logic
                  final namaRaw = p.nama;
                  String studentName = namaRaw;
                  String? presenterName;

                  if (namaRaw.contains(' | Presenter: ')) {
                    final parts = namaRaw.split(' | Presenter: ');
                    studentName = parts[0];
                    presenterName = parts.sublist(1).join(' | Presenter: ');
                  }

                  return Card(
                    color: AppColors.navySurface,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.brass.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PresensiDetailScreen(presensi: p),
                        ),
                      ).then((_) {
                        // Refresh after coming back from detail (in case they made changes or deleted)
                        if (context.mounted) {
                          context.read<RiwayatCubit>().fetchRiwayat();
                        }
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Photo Thumbnail
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.brass, width: 1.5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(27),
                                child: p.fotoUrl != null
                                    ? Image.network(
                                        p.fotoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.person, color: AppColors.brass),
                                      )
                                    : const Icon(Icons.person, color: AppColors.brass),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    studentName,
                                    style: const TextStyle(
                                      color: AppColors.ivory,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'NIM ${p.nim}',
                                    style: TextStyle(
                                      color: AppColors.charcoal.withOpacity(0.85),
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (presenterName != null) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.co_present_rounded,
                                          size: 14,
                                          color: AppColors.brass,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            'Presenter: $presenterName',
                                            style: const TextStyle(
                                              color: AppColors.ivory,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 13,
                                        color: AppColors.charcoal.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTanggal(p.createdAt),
                                        style: TextStyle(
                                          color: AppColors.charcoal,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Verifikasi Fisik Badge
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.brass.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.brass.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.brass,
                                        size: 11,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'Terverifikasi Fisik',
                                        style: TextStyle(
                                          color: AppColors.brass,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Mini Campus tag
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: AppColors.brass,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Kampus',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.charcoal.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
