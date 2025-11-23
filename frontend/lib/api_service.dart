import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000"; // 로컬 서버 주소

  Future<Map<String, dynamic>> login(String id, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": id, "role": role}),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> sendEquipmentData(
      String id, String type, String loc, double v1, double v2) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze_equipment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": id,
        "type": type,
        "location": loc,
        "val1": v1,
        "val2": v2
      }),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

