import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qurocare_test/models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Fetches all products from the FakeStore API.
  /// Throws an [Exception] if the request fails.
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products. Check your connection.');
    }
  }
}
