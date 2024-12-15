import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<Map<String, dynamic>> getBooks(int page, {String? searchQuery});
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://gutendex.com/books/';

  BookRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getBooks(int page, {String? searchQuery}) async {
    try {
      String url;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url = '$baseUrl?search=${Uri.encodeComponent(searchQuery)}';
        if (page > 1) {
          url += '&page=$page';
        }
      } else {
        url = page == 1 ? baseUrl : '$baseUrl?page=$page';
      }

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String? nextUrl = data['next'] as String?;

        if (data['results'] != null && data['results'].isNotEmpty) {
          return {
            'books': List<BookModel>.from(
                data['results'].map((bookJson) => BookModel.fromJson(bookJson))),
            'hasMore': nextUrl != null,
          };
        }
      }
      throw Exception('Failed to load books');
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }
}