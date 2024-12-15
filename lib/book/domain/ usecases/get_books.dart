import '../ repositories/book_repository.dart';

class GetBooks {
  final BookRepository repository;

  GetBooks(this.repository);

  Future<Map<String, dynamic>> execute(int page, {String? searchQuery}) {
    return repository.getBooks(page, searchQuery: searchQuery);
  }
}
