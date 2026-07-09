import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../widgets/seal_badge.dart';
import '../services/presensi_service.dart';
import '../dto/presensi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String targetNim = '2415091032';

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('Dashboard Kehadiran'),
      ),
      body: FutureBuilder<List<Presensi>>(
        future: PresensiService.getPresensiList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brass),
            );
          }

          final allPresensi = snapshot.data ?? [];
          // Filter presensi milik Adel
          final myPresensi = allPresensi.where((p) => p.nim == targetNim).toList();
          final myCount = myPresensi.length;
          const int targetCount = 10;
          final double progressPercentage = (myCount / targetCount).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Banner
                Card(
                  color: AppColors.navySurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColors.charcoal.withOpacity(0.12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const SealBadge(size: 64, icon: Icons.school),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang, Adel!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.inkNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NIM: $targetNim',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brass,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Program Studi Sistem Informasi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.charcoal.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Statistics Section (Progress Ring)
                Card(
                  color: AppColors.navySurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColors.charcoal.withOpacity(0.12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Circular Progress Indicator Stack
                        SizedBox(
                          width: 96,
                          height: 96,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: progressPercentage,
                                strokeWidth: 10,
                                color: AppColors.brass,
                                backgroundColor: AppColors.charcoal.withOpacity(0.15),
                                strokeCap: StrokeCap.round,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$myCount',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.inkNavy,
                                      ),
                                    ),
                                    Text(
                                      '/$targetCount',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.charcoal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Text description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Poin Kehadiran',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.inkNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Anda telah menghadiri $myCount dari target $targetCount seminar proposal semester ini.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.charcoal,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: progressPercentage,
                                color: AppColors.brass,
                                backgroundColor: AppColors.charcoal.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
