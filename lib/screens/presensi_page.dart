import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cubit/upload_foto_cubit.dart';
import '../cubit/upload_foto_state.dart';
import '../config/app_theme.dart';
import '../widgets/seal_badge.dart';
import '../services/presensi_service.dart';

class PresensiPage extends StatelessWidget {
  const PresensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadFotoCubit(),
      child: const _PresensiForm(),
    );
  }
}

class _PresensiForm extends StatefulWidget {
  const _PresensiForm();

  @override
  State<_PresensiForm> createState() => _PresensiFormState();
}

class _PresensiFormState extends State<_PresensiForm> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _presenterController = TextEditingController();
  final _presenterProdiController = TextEditingController();
  final _tanggalController = TextEditingController();
  DateTime? _selectedDate;
  XFile? _fotoFile;
  Uint8List? _fotoBytes;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _presenterController.dispose();
    _presenterProdiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.inkNavy,
              onPrimary: Colors.white,
              onSurface: AppColors.inkNavy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _tanggalController.text = "${pickedDate.day} ${_getNamaBulan(pickedDate.month)} ${pickedDate.year}";
      });
    }
  }

  String _getNamaBulan(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  Future<void> _ambilFoto() async {
    if (!kIsWeb) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin kamera diperlukan untuk mengambil foto'),
            ),
          );
        }
        return;
      }
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _fotoFile = pickedFile;
        _fotoBytes = bytes;
      });
    }
  }

  void _showSuccessSeal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1600), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SealBadge(size: 130, icon: Icons.verified_rounded),
                const SizedBox(height: 20),
                Text(
                  'Presensi Berhasil!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tercatat Resmi di Sistem SIFORS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() async {
    final studentName = _namaController.text.trim();
    final nim = _nimController.text.trim();
    final presenterName = _presenterController.text.trim();
    final presenterProdi = _presenterProdiController.text.trim();
    final tanggal = _tanggalController.text.trim();

    if (studentName.isEmpty || nim.isEmpty || presenterName.isEmpty || presenterProdi.isEmpty || tanggal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.rust,
          content: Text('Silakan lengkapi semua field terlebih dahulu'),
        ),
      );
      return;
    }
    if (_fotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.rust,
          content: Text('Silakan ambil foto bukti fisik'),
        ),
      );
      return;
    }

    // 1. Cek sudah presensi hari ini
    try {
      final sudah = await PresensiService.sudahPresensiHariIni(nim);
      if (sudah) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.rust,
            content: Text('NIM ini sudah melakukan presensi hari ini'),
          ),
        );
        return;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.rust,
          content: Text('Gagal verifikasi presensi: $e'),
        ),
      );
      return;
    }

    if (!mounted) return;

    // 2. Concatenate nama logic
    final fullName = "$studentName | Presenter: $presenterName | Prodi: $presenterProdi | Tanggal: $tanggal";

    // 3. Submit with static Undiksha Kampus Tengah coordinates
    context.read<UploadFotoCubit>().submit(
      nama: fullName,
      nim: nim,
      foto: _fotoFile!,
      latitude: -8.1162,
      longitude: 115.0894,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presensi Seminar')),
      body: BlocConsumer<UploadFotoCubit, UploadFotoState>(
        listener: (context, state) {
          if (state is UploadFotoSuccess) {
            _showSuccessSeal(context);
            _namaController.clear();
            _nimController.clear();
            _presenterController.clear();
            _presenterProdiController.clear();
            _tanggalController.clear();
            setState(() {
              _fotoFile = null;
              _fotoBytes = null;
              _selectedDate = null;
            });
            context.read<UploadFotoCubit>().reset();
          } else if (state is UploadFotoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.rust,
                content: Text('Gagal mengirim presensi: ${state.message}'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UploadFotoLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Formulir Kehadiran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.inkNavy,
                  ),
                ),
                const SizedBox(height: 16),

                // Form Fields
                TextField(
                  controller: _namaController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.inkNavy, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap Mahasiswa',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.inkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _nimController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.inkNavy, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'NIM Mahasiswa',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: AppColors.inkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _presenterController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.inkNavy, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'Nama Presenter Seminar',
                    prefixIcon: Icon(
                      Icons.co_present_outlined,
                      color: AppColors.inkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _presenterProdiController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.inkNavy, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'Program Studi Presenter',
                    prefixIcon: Icon(
                      Icons.school_outlined,
                      color: AppColors.inkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _tanggalController,
                  enabled: !isLoading,
                  readOnly: true,
                  onTap: () => _pilihTanggal(context),
                  style: const TextStyle(color: AppColors.inkNavy, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Seminar',
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.inkNavy,
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.inkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Grab-style Safe Location Card (Restyled to clean white)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.inkNavy.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.inkNavy.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location_rounded,
                          color: AppColors.inkNavy,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             const Text(
                              'Kampus Tengah Undiksha',
                              style: TextStyle(
                                color: AppColors.inkNavy,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Lokasi: Kampus Tengah Undiksha (Akurasi Tinggi)',
                              style: TextStyle(
                                color: AppColors.sage,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Koordinat: -8.11620, 115.08940',
                              style: TextStyle(
                                color: AppColors.charcoal.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Bukti Kehadiran Fisik',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.inkNavy,
                  ),
                ),
                const SizedBox(height: 10),

                // Beautiful Card Photo Box (Restyled to clean white/grey)
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _fotoFile != null
                          ? AppColors.inkNavy.withOpacity(0.3)
                          : AppColors.inkNavy.withOpacity(0.05),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _fotoFile != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_fotoBytes!, fit: BoxFit.cover),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.sage,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.sage,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Bukti Terunggah',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo_rounded,
                                size: 48,
                                color: AppColors.inkNavy.withOpacity(0.4),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Formulir Kehadiran Seminar',
                                style: TextStyle(
                                  color: AppColors.inkNavy,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ambil foto fisik kartu kontrol seminar',
                                style: TextStyle(
                                  color: AppColors.charcoal.withOpacity(0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                // Capture Button
                OutlinedButton.icon(
                  onPressed: isLoading ? null : _ambilFoto,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(
                    _fotoFile == null
                        ? 'Ambil Foto Bukti'
                        : 'Ulangi Ambil Foto',
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kirim Presensi Kehadiran'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
