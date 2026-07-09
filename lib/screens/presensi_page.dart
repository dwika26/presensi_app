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
  final ValueNotifier<String?>? presenterNotifier;

  const PresensiPage({super.key, this.presenterNotifier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadFotoCubit(),
      child: _PresensiForm(presenterNotifier: presenterNotifier),
    );
  }
}

class _PresensiForm extends StatefulWidget {
  final ValueNotifier<String?>? presenterNotifier;

  const _PresensiForm({this.presenterNotifier});

  @override
  State<_PresensiForm> createState() => _PresensiFormState();
}

class _PresensiFormState extends State<_PresensiForm> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _presenterController = TextEditingController();
  XFile? _fotoFile;
  Uint8List? _fotoBytes;

  @override
  void initState() {
    super.initState();
    _presenterController.text = widget.presenterNotifier?.value ?? '';
    widget.presenterNotifier?.addListener(_onPresenterChanged);
  }

  void _onPresenterChanged() {
    if (mounted) {
      setState(() {
        _presenterController.text = widget.presenterNotifier?.value ?? '';
      });
    }
  }

  @override
  void dispose() {
    widget.presenterNotifier?.removeListener(_onPresenterChanged);
    _namaController.dispose();
    _nimController.dispose();
    _presenterController.dispose();
    super.dispose();
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

    if (studentName.isEmpty || nim.isEmpty || presenterName.isEmpty) {
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
          content: Text('Silakan ambil foto bukti fisik card control'),
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
    final fullName = "$studentName | Presenter: $presenterName";

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
            if (widget.presenterNotifier != null) {
              widget.presenterNotifier!.value = null;
            }
            setState(() {
              _fotoFile = null;
              _fotoBytes = null;
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
                // Section Title
                const Text(
                  'Formulir Kehadiran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ivory,
                  ),
                ),
                const SizedBox(height: 16),

                // Form Fields
                TextField(
                  controller: _namaController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.ivory),
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap Mahasiswa',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.brass,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _nimController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.ivory),
                  decoration: const InputDecoration(
                    labelText: 'NIM Mahasiswa',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: AppColors.brass,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _presenterController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.ivory),
                  decoration: InputDecoration(
                    labelText: 'Nama Presenter Seminar',
                    prefixIcon: const Icon(
                      Icons.co_present_outlined,
                      color: AppColors.brass,
                    ),
                    helperText:
                        'Bisa dipilih otomatis dari Tab Profil / Daftar Presenter',
                    helperStyle: TextStyle(
                      color: AppColors.charcoal.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Grab-style Safe Location Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.brass.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.brass.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location_rounded,
                          color: AppColors.brass,
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
                                color: AppColors.ivory,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Lokasi: Kampus Tengah Undiksha (Akurasi Tinggi)',
                              style: TextStyle(
                                color: AppColors.brass,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Koordinat: -8.11620, 115.08940',
                              style: TextStyle(
                                color: AppColors.charcoal,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Photo Area Title
                const Text(
                  'Bukti Kehadiran Fisik',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ivory,
                  ),
                ),
                const SizedBox(height: 10),

                // Beautiful Card Photo Box
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.navySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _fotoFile != null
                          ? AppColors.brass.withOpacity(0.4)
                          : AppColors.charcoal.withOpacity(0.2),
                      width: 1.5,
                    ),
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
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.brass.withOpacity(0.5),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.brass,
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
                                color: AppColors.brass.withOpacity(0.8),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Formulir Kehadiran Seminar',
                                style: TextStyle(
                                  color: AppColors.ivory,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ambil foto fisik kartu kontrol seminar',
                                style: TextStyle(
                                  color: AppColors.charcoal,
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
