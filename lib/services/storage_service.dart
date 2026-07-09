import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

class StorageService {
  static const String bucketName = 'foto-presensi';

  /// Upload file foto, kembalikan public URL-nya
  static Future<String> uploadFoto(XFile file) async {
    final fileName = 'presensi_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final url = Uri.parse('${SupabaseConfig.storageUrl}/object/$bucketName/$fileName');

    final bytes = await file.readAsBytes();

    final response = await http.post(
      url,
      headers: {
        'apikey': SupabaseConfig.apiKey,
        'Authorization': 'Bearer ${SupabaseConfig.apiKey}',
        'Content-Type': 'image/jpeg',
      },
      body: bytes,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return '${SupabaseConfig.storageUrl}/object/public/$bucketName/$fileName';
    } else {
      throw Exception('Gagal upload foto: ${response.statusCode} ${response.body}');
    }
  }
}