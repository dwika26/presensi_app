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
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: AppColors.inkNavy.withOpacity(0.08),
                  indent: 72,
                ),
                itemBuilder: (context, index) {
                  final p = list[index];
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PresensiDetailScreen(presensi: p)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.brass, width: 1.4),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage: p.fotoUrl != null ? NetworkImage(p.fotoUrl!) : null,
                        backgroundColor: AppColors.inkNavy.withOpacity(0.08),
                        child: p.fotoUrl == null
                            ? Icon(Icons.person, color: AppColors.inkNavy.withOpacity(0.4))
                            : null,
                      ),
                    ),
                    title: Text(p.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('NIM ${p.nim}'),
                    trailing: p.latitude != null
                        ? const Icon(Icons.location_on, color: AppColors.brass, size: 18)
                        : null,
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