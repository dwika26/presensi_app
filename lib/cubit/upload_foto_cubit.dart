import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../dto/presensi.dart';
import '../services/presensi_service.dart';
import '../services/storage_service.dart';
import 'upload_foto_state.dart';

class UploadFotoCubit extends Cubit<UploadFotoState> {
  UploadFotoCubit() : super(UploadFotoIdle());

  Future<void> submit({
    required String nama,
    required String nim,
    required XFile foto,
    double? latitude,
    double? longitude,
  }) async {
    emit(UploadFotoLoading());
    try {
      final fotoUrl = await StorageService.uploadFoto(foto);
      final presensi = Presensi(
        nama: nama,
        nim: nim,
        fotoUrl: fotoUrl,
        latitude: latitude,
        longitude: longitude,
      );
      await PresensiService.createPresensi(presensi);
      emit(UploadFotoSuccess());
    } catch (e) {
      emit(UploadFotoFailure(e.toString()));
    }
  }

  void reset() => emit(UploadFotoIdle());
}