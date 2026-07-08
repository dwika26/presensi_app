import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _members = [
    {'name': 'Jyottie', 'nim': '222'},
    {'name': 'Adel', 'nim': '222'},
    {'name': 'Anggik', 'nim': '222'},
    {'name': 'Indra', 'nim': '222'},
    {'name': 'Dwi', 'nim': '222'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Kelompok')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _members.length,
        itemBuilder: (context, i) {
          final m = _members[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inkNavy,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brass.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.brass, width: 1.4),
                  ),
                  child: Icon(Icons.person, color: AppColors.ivory),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m['name']!,
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'NIM ${m['nim']}',
                      style: TextStyle(
                        color: AppColors.ivory.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
