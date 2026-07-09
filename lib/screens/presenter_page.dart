import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class PresenterPage extends StatelessWidget {
  final Function(String) onPresenterSelected;

  const PresenterPage({super.key, required this.onPresenterSelected});

  static const _presenters = [
    {
      'name': 'I Putu Eka Surya',
      'nim': '2015091001',
      'topic': 'Rancang Bangun Sistem Informasi Geografis Potensi Daerah',
      'time': '08:30 - 09:30 WITA',
      'room': 'Ruang Kuliah 3',
    },
    {
      'name': 'Made Satya Wira',
      'nim': '2015091024',
      'topic': 'Klasifikasi Sentimen Ulasan Kuliner Bali Menggunakan BERT',
      'time': '09:30 - 10:30 WITA',
      'room': 'Lab Komputer SIFORS',
    },
    {
      'name': 'Luh Putu Jyottie Lestari',
      'nim': '2015091035',
      'topic': 'Implementasi Algoritma A* Untuk Pencarian Rute Tercepat Ambulans',
      'time': '10:30 - 11:30 WITA',
      'room': 'Ruang Sidang Teknik',
    },
    {
      'name': 'Gede Anggika Pratama',
      'nim': '2015091048',
      'topic': 'Sistem Pendukung Keputusan Pemilihan Dosen Pembimbing Skripsi',
      'time': '13:00 - 14:00 WITA',
      'room': 'Ruang Kuliah 3',
    },
    {
      'name': 'Ni Wayan Adelia Putri',
      'nim': '2015091060',
      'topic': 'Deteksi Dini Penyakit Tanaman Cengkeh Berbasis CNN MobileNet',
      'time': '14:00 - 15:00 WITA',
      'room': 'Lab Komputer SIFORS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Presenter'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner/Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.campaign_rounded, color: AppColors.brass, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Presenter Sempro Aktif',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.inkNavy,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih salah satu presenter di bawah untuk merekam kehadiran presensi seminar proposal.',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _presenters.length,
              itemBuilder: (context, index) {
                final presenter = _presenters[index];
                final name = presenter['name']!;
                final initials = name.split(' ').map((e) => e[0]).take(2).join('');

                return Card(
                  color: AppColors.navySurface,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.charcoal.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onPresenterSelected(name),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Initials Avatar
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.brass.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.brass.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  color: AppColors.brass,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: AppColors.inkNavy,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'NIM ${presenter['nim']}',
                                  style: TextStyle(
                                    color: AppColors.charcoal.withOpacity(0.85),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  presenter['topic']!,
                                  style: const TextStyle(
                                    color: AppColors.inkNavy,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 6,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.access_time_filled_rounded,
                                          size: 14,
                                          color: AppColors.brass,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          presenter['time']!,
                                          style: const TextStyle(
                                            color: AppColors.charcoal,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.meeting_room_rounded,
                                          size: 14,
                                          color: AppColors.brass,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          presenter['room']!,
                                          style: const TextStyle(
                                            color: AppColors.charcoal,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Grab-style Arrow or Button
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.brass.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.brass,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Pilih',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.brass,
                                  fontWeight: FontWeight.w700,
                                ),
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
          ),
        ],
      ),
    );
  }
}
