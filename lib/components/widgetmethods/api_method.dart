import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class ApiService {
   Future<Map<String, dynamic>> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    bool tokenRequired = false,
  }) async {
    if (tokenRequired) {
      final token = await _getToken();
      if (token == null) {
        return {
          'message': 'Token is required but not found.',
        };
      }
      return _sendRequestWithToken(method, endpoint, body, token);
    } else {
      return _sendRequestWithoutToken(method, endpoint, body);
    }
  }

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _sendRequestWithToken(String method,
      String endpoint, Map<String, dynamic>? body, String token) async {
    try {
      final uri = Uri.parse('${Config.apiUrl}$endpoint');
      print(uri);

      final headers = _getHeaders(token);
      final requestBody = body != null ? json.encode(body) : null;
      return await _sendRequest(method, uri, headers, requestBody);
    } catch (e) {
      return {
        'statusCode': 500,
        'message': 'An error occurred while making the request: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> _sendRequestWithoutToken(String method,
      String endpoint, Map<String, dynamic>? body) async {
    try {
      final uri = Uri.parse('${Config.apiUrl}$endpoint');
      final headers = {
        'Content-Type': 'application/json',
      };
      final requestBody = body != null ? json.encode(body) : null;
      return await _sendRequest(method, uri, headers, requestBody);
    } catch (e) {
      return {
        'statusCode': 500,
        'message': 'An error occurred while making the request: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> _sendRequest(String method, Uri uri,
      Map<String, String> headers, String? body) async {
    try {

      http.Response response;

      switch (method.toLowerCase()) {
        case 'get':
          response = await http.get(uri, headers: headers);
          break;
        case 'post':
          response = await http.post(uri, headers: headers, body: body);
          break;
        case 'put':
          response = await http.put(uri, headers: headers, body: body);
          break;
        case 'delete':
          response = await http.delete(uri, headers: headers, body: body);
          break;
        default:
          return {
            'statusCode': 400,
            'message': 'Invalid HTTP method.',
          };
      }

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }  else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {
        'statusCode': 500,
        'message': 'Check Your API',
      };
    }
  }
}