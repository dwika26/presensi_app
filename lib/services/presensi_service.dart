import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import '../dto/presensi.dart';

class PresensiService {
  static Map<String, String> get _headers => {
        'apikey': SupabaseConfig.apiKey,
        'Authorization': 'Bearer ${SupabaseConfig.apiKey}',
        'Content-Type': 'application/json',
      };

  static Future<List<Presensi>> getPresensiList() async {
    final url = Uri.parse(
        '${SupabaseConfig.baseUrl}/presensi?select=*&order=created_at.desc');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Presensi.fromJson(json)).toList();
    } else {
      throw Exception(
          'Gagal ambil data presensi: ${response.statusCode} ${response.body}');
    }
  }

  static Future<bool> createPresensi(Presensi presensi) async {
    final url = Uri.parse('${SupabaseConfig.baseUrl}/presensi');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(presensi.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Gagal kirim presensi: ${response.statusCode} ${response.body}');
    }
  }

  static Future<bool> sudahPresensiHariIni(String nim) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
    final url = Uri.parse(
      '${SupabaseConfig.baseUrl}/presensi?select=id&nim=eq.$nim&created_at=gte.$startOfDay&limit=1',
    );
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.isNotEmpty;
    } else {
      throw Exception('Gagal cek presensi: ${response.statusCode}');
    }
  }
}