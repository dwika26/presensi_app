import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubit/riwayat_cubit.dart';
import '../cubit/riwayat_state.dart';
import 'presensi_detail_screen.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RiwayatCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Riwayat Presensi')),
        body: BlocBuilder<RiwayatCubit, RiwayatState>(
          builder: (context, state) {
            if (state is RiwayatLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RiwayatError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Gagal memuat data: ${state.message}'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<RiwayatCubit>().fetchRiwayat(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final list = (state as RiwayatLoaded).data;

            if (list.isEmpty) {
              return const Center(child: Text('Belum ada data presensi'));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<RiwayatCubit>().fetchRiwayat(),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Summary Card (Similar to right screen in mockup)
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navySurface, AppColors.inkNavy],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.inkNavy.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ringkasan Kehadiran',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.brass,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Real-time',
                                style: TextStyle(
                                  color: AppColors.inkNavy,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${list.length} Presensi Tercatat',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Data disinkronkan secara aman dengan database Supabase SIFORS.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Kehadiran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.inkNavy,
                        ),
                      ),
                      Text(
                        'Semua Kelas',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.charcoal.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // List of presence items rendered as modern white card blocks
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final p = list[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.inkNavy.withOpacity(0.04)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PresensiDetailScreen(presensi: p)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.brass, width: 1.8),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: p.fotoUrl != null ? NetworkImage(p.fotoUrl!) : null,
                              backgroundColor: AppColors.inkNavy.withOpacity(0.06),
                              child: p.fotoUrl == null
                                  ? Icon(Icons.person, color: AppColors.inkNavy.withOpacity(0.4))
                                  : null,
                            ),
                          ),
                          title: Text(
                            p.nama, 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.inkNavy,
                            ),
                          ),
                          subtitle: Text(
                            'NIM ${p.nim}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.charcoal.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (p.latitude != null)
                                const Icon(Icons.location_on_rounded, color: AppColors.sage, size: 16),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded, color: AppColors.charcoal.withOpacity(0.4), size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}