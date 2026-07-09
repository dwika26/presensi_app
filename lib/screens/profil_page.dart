import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  static const _groupMembers = [
    {'name': 'Ni Made Dwijothamy Oka', 'nim': '2415091023'},
    {'name': 'Ni Kadek Adelia Holistya Putri', 'nim': '2415091032'},
    {'name': 'Kadek Indra Setiawan', 'nim': '2415091055'},
    {'name': 'Ni Kadek Anggi Sintya Putri', 'nim': '2415091079'},
    {'name': 'Muhammad Dwi Ramadhan', 'nim': '2415091084'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Kelompok')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Group Profile Card
            Card(
              color: AppColors.navySurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.charcoal.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Large Avatar with initials
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.brass.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.brass, width: 2.5),
                      ),
                      child: const Center(
                        child: Text(
                          'K3',
                          style: TextStyle(
                            color: AppColors.brass,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Kelompok 3',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelas SI 4A',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brass,
                      ),
                    ),
                    const Divider(height: 32, thickness: 1),
                    // Detail Rows
                    _buildInfoRow(
                      Icons.menu_book_rounded,
                      'Mata Kuliah',
                      'Pemrograman Mobile',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.school,
                      'Program Studi',
                      'Sistem Informasi (SIFORS)',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.location_city,
                      'Universitas',
                      'Universitas Pendidikan Ganesha',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Tim Pengembang Kelompok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.inkNavy,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _groupMembers.length,
              itemBuilder: (context, i) {
                final member = _groupMembers[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.charcoal.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.charcoal.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['name']!,
                              style: const TextStyle(
                                color: AppColors.inkNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NIM ${member['nim']}',
                              style: const TextStyle(
                                color: AppColors.charcoal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.brass),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
