import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/presensi_service.dart';
import 'riwayat_state.dart';

class RiwayatCubit extends Cubit<RiwayatState> {
  RiwayatCubit() : super(RiwayatLoading()) {
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    if (isClosed) return;
    emit(RiwayatLoading());
    try {
      final data = await PresensiService.getPresensiList();
      if (isClosed) return;
      emit(RiwayatLoaded(data));
    } catch (e) {
      if (isClosed) return;
      emit(RiwayatError(e.toString()));
    }
  }
}