import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:looneytube/application/entities/category.dart';
import 'package:looneytube/application/local_storage.dart';

Future<String?> _getToken() async {
  return await getSingleFromLocalStorage('auth', 'token');
}

Future<bool> _isTokenPresent() async {
  return (await _getToken()) != null;
}

Future<Map<String, String>> _getAuthorizedHeaders() async {
  return {
    'Authorization': 'Bearer ${await _getToken()}'
  };
}

Future<http.Response> _get(String url) async {
  if (!(await _isTokenPresent())) {
    await _login();

    return await _get(url);
  }

  final response = await http.get(
    Uri.parse('https://api.looneytube.tv/$url'),
    headers: (await _getAuthorizedHeaders())
  );

  if (response.statusCode == 401) {
    await _login();

    return await _get(url);
  }

  return response;
}

_login() async {
  final response = await http.post(
      Uri.parse('https://api.looneytube.tv/login'),
      body: {
        '_username': dotenv.env['LOONEYTUBE_USER'],
        '_password': dotenv.env['LOONEYTUBE_PASSWORD']
      }
  );

  if (response.statusCode != 200) {
    throw Exception('Could not login :/');
  }

  storeSingle('auth', 'token', jsonDecode(response.body)['token']);
}

Future<List<Category>> fetchCategories() async {
  final response = await _get('categories');

  if (response.statusCode == 200) {
    return Category.collectionFromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<Category> fetchCategory(String slug) async {
  final response = await _get('category/$slug');

  if (response.statusCode == 200) {
    return Category.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load category "$slug"');
  }
}
