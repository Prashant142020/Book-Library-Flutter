class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    String authorName = 'Unknown';
    if (json['authors'] != null && json['authors'].isNotEmpty) {
      authorName = json['authors'][0]['name'];
    }

    return Book(
      id: json['id'],
      title: json['title'],
      author: authorName,
      coverUrl: json['formats']['image/jpeg'] ?? '',
    );
  }
}