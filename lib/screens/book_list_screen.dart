import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  List<Book> books = [];
  bool isLoading = false;
  int page = 1;
  bool hasMore = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _bookService.fetchBooks(page);
      final newBooks = result['books'] as List<Book>;
      final hasMorePages = result['hasMore'] as bool;

      if (mounted) {
        setState(() {
          if (newBooks.isNotEmpty) {
            books.addAll(newBooks);
            page++;
          }
          hasMore = hasMorePages;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load books: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadBooks,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Discovery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: BookSearchDelegate(books),
              );
              if (result != null) {
                setState(() {
                  query = result;
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            books.clear();
            page = 1;
            hasMore = true;
          });
          await _loadBooks();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!isLoading &&
                hasMore &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              _loadBooks();
            }
            return false;
          },
          child: filteredBooks.isEmpty
              ? const Center(
                  child: Text('No books found'),
                )
              : ListView.builder(
                  itemCount: filteredBooks.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredBooks.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    var book = filteredBooks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: CachedNetworkImage(
                            imageUrl: book.coverUrl,
                            width: 50,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailScreen(book: book),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  String get searchFieldLabel => 'Search by title or author';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where(
          (book) => book.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book.title);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var book = suggestions[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text("by${book.author}"),
          onTap: () {
            close(context, book.title);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    throw UnimplementedError();
  }
}