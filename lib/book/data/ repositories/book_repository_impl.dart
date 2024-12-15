import '../ datasources/book_remote_data_source.dart';
import '../../domain/ repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getBooks(int page, {String? searchQuery}) async {
    return await remoteDataSource.getBooks(page, searchQuery: searchQuery);
  }
}
