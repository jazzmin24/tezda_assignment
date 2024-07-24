import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tezda_assignment/model/product_model.dart';

Future<List<ProductModel>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => ProductModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
