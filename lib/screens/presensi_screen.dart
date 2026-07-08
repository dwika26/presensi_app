import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cubit/upload_foto_cubit.dart';
import '../cubit/upload_foto_state.dart';
import 'package:geolocator/geolocator.dart';
import '../config/app_theme.dart';
import '../widgets/seal_badge.dart';
import '../config/campus_config.dart';
import '../services/presensi_service.dart';

class PresensiScreen extends StatelessWidget {
  const PresensiScreen({super.key});

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
  File? _fotoFile;

  Future<void> _ambilFoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Izin kamera ditolak')));
      }
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _fotoFile = File(pickedFile.path));
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aktifkan GPS/Location dulu ya')),
        );
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  void _showSuccessSeal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (Navigator.of(dialogContext).canPop())
            Navigator.of(dialogContext).pop();
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
                const SealBadge(size: 120, icon: Icons.check_rounded),
                const SizedBox(height: 16),
                Text(
                  'Presensi Tercatat',
                  style: TextStyle(
                    color: AppColors.ivory,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
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
    final nama = _namaController.text.trim();
    final nim = _nimController.text.trim();
    if (nama.isEmpty || nim.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama dan NIM wajib diisi')));
      return;
    }
    if (_fotoFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Silakan ambil foto dulu')));
      return;
    }

    // 1. Cek sudah presensi hari ini atau belum
    try {
      final sudah = await PresensiService.sudahPresensiHariIni(nim);
      if (sudah) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamu sudah presensi hari ini')),
        );
        return;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal cek presensi: $e')));
      return;
    }

    // 2. Ambil lokasi
    final position = await _getCurrentLocation();
    if (position == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aktifkan GPS & izinkan lokasi untuk presensi'),
        ),
      );
      return;
    }

    // 3. Cek jarak dari kampus
    final distance = Geolocator.distanceBetween(
      CampusConfig.latitude,
      CampusConfig.longitude,
      position.latitude,
      position.longitude,
    );
    if (distance > CampusConfig.allowedRadiusMeters) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kamu berada ${distance.toStringAsFixed(0)} m dari kampus '
            '(maksimal ${CampusConfig.allowedRadiusMeters.toStringAsFixed(0)} m). Presensi ditolak.',
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    context.read<UploadFotoCubit>().submit(
      nama: nama,
      nim: nim,
      foto: _fotoFile!,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presensi')),
      body: BlocConsumer<UploadFotoCubit, UploadFotoState>(
        listener: (context, state) {
          if (state is UploadFotoSuccess) {
            _showSuccessSeal(context);
            _namaController.clear();
            _nimController.clear();
            setState(() => _fotoFile = null);
            context.read<UploadFotoCubit>().reset();
          } else if (state is UploadFotoFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.rust,
                content: Text('Gagal: ${state.message}'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UploadFotoLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_fotoFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _fotoFile!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.brass, width: 1.6),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _fotoFile != null
                        ? Image.file(
                            _fotoFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.badge_outlined,
                                  size: 56,
                                  color: AppColors.inkNavy.withOpacity(0.35),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Foto untuk bukti kehadiran',
                                  style: TextStyle(
                                    color: AppColors.charcoal.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isLoading ? null : _ambilFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    _fotoFile == null ? 'Ambil Foto' : 'Ambil Ulang Foto',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kirim Presensi'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
