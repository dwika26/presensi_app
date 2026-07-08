import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../widgets/seal_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.inkNavy,
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
            child: Column(
              children: [
                const SealBadge(size: 88),
                const SizedBox(height: 16),
                Text(
                  'Presensi SIFORS',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: AppColors.ivory),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bukti kehadiran, tercatat resmi.',
                  style: TextStyle(
                    color: AppColors.ivory.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gunakan menu Presensi untuk merekam kehadiran kamu hari ini — lengkap dengan foto dan lokasi.',
                    style: TextStyle(
                      color: AppColors.charcoal.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
