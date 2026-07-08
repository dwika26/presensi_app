import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/presensi_service.dart';
import 'riwayat_state.dart';

class RiwayatCubit extends Cubit<RiwayatState> {
  RiwayatCubit() : super(RiwayatLoading()) {
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    emit(RiwayatLoading());
    try {
      final data = await PresensiService.getPresensiList();
      emit(RiwayatLoaded(data));
    } catch (e) {
      emit(RiwayatError(e.toString()));
    }
  }
}