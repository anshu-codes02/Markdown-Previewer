import 'dart:convert';
import 'package:http/http.dart' as http;

class MarkdownService {
  static const String baseUrl = "http://localhost:8000/markdown";

  static Future<String?> renderMarkdown(String markdown) async {

    final response = await http.post(
      Uri.parse("$baseUrl/render"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"markdown": markdown}),
    );

    print("Render response: ${jsonDecode(response.body)}"); // Debug log

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  static Future<bool> saveMarkdown(String key, String markdown) async {
    final response = await http.post(
      Uri.parse("$baseUrl/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "key": key,
        "markdown": markdown,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<String?> retrieveMarkdown(String key) async {
    final response = await http.get(
      Uri.parse("$baseUrl/note/$key"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['markdown'];
    }
    return null;
  }
}