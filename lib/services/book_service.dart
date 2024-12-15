import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String baseUrl = 'https://gutendex.com/books/';
  String? nextUrl;

  Future<Map<String, dynamic>> fetchBooks(int page, {String? searchQuery}) async {
    try {
      String url;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Add search parameter to the URL
        url = '$baseUrl?search=${Uri.encodeComponent(searchQuery)}';
        if (page > 1) {
          url += '&page=$page';
        }
      } else {
        url = page == 1 ? baseUrl : '$baseUrl?page=$page';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
