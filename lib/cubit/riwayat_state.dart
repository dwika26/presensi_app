import '../dto/presensi.dart';

abstract class RiwayatState {}

class RiwayatLoading extends RiwayatState {}

class RiwayatLoaded extends RiwayatState {
  final List<Presensi> data;
  RiwayatLoaded(this.data);
}

class RiwayatError extends RiwayatState {
  final String message;
  RiwayatError(this.message);
}
