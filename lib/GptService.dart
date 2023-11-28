import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env/env.dart';

class GptService {
  static Future<String> generateText(String prompt) async {
    String model = "text-davinci-002";
    String apiKey = Env.apiKey;
    var response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/$model/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 100,
        'temperature': 0.5,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['text'];
    } else {
      var errorResponse = jsonDecode(response.body);
      throw Exception("Error: ${errorResponse['error']['message']}");
    }
  }
}
