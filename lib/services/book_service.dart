import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String baseUrl = 'https://gutendex.com/books/';
  String? nextUrl;

  Future<Map<String, dynamic>> fetchBooks(int page) async {
    try {
      final url = page == 1 ? baseUrl : '$baseUrl?page=$page';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Store the next URL for pagination
        nextUrl = data['next'] as String?;

        if (data['results'] != null && data['results'].isNotEmpty) {
          return {
            'books': List<Book>.from(
                data['results'].map((bookJson) => Book.fromJson(bookJson))),
            'hasMore': nextUrl != null,
          };
        } else {
          return {
            'books': <Book>[],
            'hasMore': false,
          };
        }
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  bool hasNextPage() {
    return nextUrl != null;
  }
}
