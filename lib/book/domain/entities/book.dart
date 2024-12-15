class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final List<String> downloadUrls;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrls,
  });
}
