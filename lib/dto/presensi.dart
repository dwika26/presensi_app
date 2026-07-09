class Presensi {
  final int? id;
  final String nama;
  final String nim;
  final String? fotoUrl;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final String? presenterName;
  final String? presenterProdi;
  final String? tanggalSeminar;

  Presensi({
    this.id,
    required this.nama,
    required this.nim,
    this.fotoUrl,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.presenterName,
    this.presenterProdi,
    this.tanggalSeminar,
  });

  factory Presensi.fromJson(Map<String, dynamic> json) {
    return Presensi(
      id: json['id'] as int?,
      nama: json['nama'] as String,
      nim: json['nim'] as String,
      fotoUrl: json['foto_url'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      presenterName: json['presenter_name'] as String?,
      presenterProdi: json['presenter_prodi'] as String?,
      tanggalSeminar: json['tanggal_seminar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      if (fotoUrl != null) 'foto_url': fotoUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (presenterName != null) 'presenter_name': presenterName,
      if (presenterProdi != null) 'presenter_prodi': presenterProdi,
      if (tanggalSeminar != null) 'tanggal_seminar': tanggalSeminar,
    };
  }
}