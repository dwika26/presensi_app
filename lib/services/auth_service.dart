import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';

class AuthService {
  static Map<String, String> get _headers => {
        'apikey': SupabaseConfig.apiKey,
        'Authorization': 'Bearer ${SupabaseConfig.apiKey}',
        'Content-Type': 'application/json',
      };

  static const String _keyNim = 'user_nim';
  static const String _keyNama = 'user_nama';

  /// Register / Sign Up baru
  static Future<bool> signUp({
    required String nim,
    required String nama,
    required String password,
  }) async {
    // 1. Cek apakah NIM sudah terdaftar
    final checkUrl = Uri.parse('${SupabaseConfig.baseUrl}/mahasiswa?nim=eq.$nim');
    final checkResponse = await http.get(checkUrl, headers: _headers);

    if (checkResponse.statusCode == 200) {
      final List<dynamic> data = jsonDecode(checkResponse.body);
      if (data.isNotEmpty) {
        throw Exception('NIM sudah terdaftar. Silakan login.');
      }
    } else {
      throw Exception('Gagal memverifikasi NIM: ${checkResponse.statusCode}');
    }

    // 2. Simpan user baru ke database
    final registerUrl = Uri.parse('${SupabaseConfig.baseUrl}/mahasiswa');
    final body = jsonEncode({
      'nim': nim,
      'nama': nama,
      'password': password,
    });

    final response = await http.post(registerUrl, headers: _headers, body: body);

    if (response.statusCode == 201) {
      // Langsung login otomatis setelah berhasil sign up
      await saveSession(nim: nim, nama: nama);
      return true;
    } else {
      throw Exception('Registrasi gagal: ${response.statusCode} ${response.body}');
    }
  }

  /// Login / Sign In
  static Future<bool> signIn({
    required String nim,
    required String password,
  }) async {
    final url = Uri.parse('${SupabaseConfig.baseUrl}/mahasiswa?nim=eq.$nim');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) {
        throw Exception('NIM tidak terdaftar. Silakan registrasi terlebih dahulu.');
      }

      final user = data.first;
      final dbPassword = user['password'] as String;

      if (dbPassword == password) {
        final nama = user['nama'] as String;
        await saveSession(nim: nim, nama: nama);
        return true;
      } else {
        throw Exception('Password salah. Silakan coba lagi.');
      }
    } else {
      throw Exception('Gagal melakukan login: ${response.statusCode}');
    }
  }

  /// Menyimpan data session ke SharedPreferences lokal
  static Future<void> saveSession({required String nim, required String nama}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNim, nim);
    await prefs.setString(_keyNama, nama);
  }

  /// Mengambil NIM user yang sedang login
  static Future<String?> getLoggedInNim() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNim);
  }

  /// Mengambil Nama user yang sedang login
  static Future<String?> getLoggedInNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNama);
  }

  /// Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final nim = await getLoggedInNim();
    return nim != null;
  }

  /// Logout (Hapus data session lokal)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNim);
    await prefs.remove(_keyNama);
  }
}
