abstract class BookRepository {
  Future<Map<String, dynamic>> getBooks(int page, {String? searchQuery});
}
