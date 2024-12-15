import 'dart:convert';

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

  factory Book.fromJson(Map<String, dynamic> json) {
    // Decode title with UTF-8
    String decodedTitle = utf8.decode(json['title'].toString().codeUnits);
    
    // Get author names
    String authorName = 'Unknown';
    if (json['authors'] != null && json['authors'].isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? 'Unknown';
      // Decode author name with UTF-8
      authorName = utf8.decode(authorName.codeUnits);
    }

    // Get cover URL
    String cover = 'https://via.placeholder.com/150';
    if (json['formats'] != null && json['formats']['image/jpeg'] != null) {
      cover = json['formats']['image/jpeg'];
    }

    // Get download URLs
    List<String> downloads = [];
    if (json['formats'] != null) {
      if (json['formats']['application/epub+zip'] != null) {
        downloads.add(json['formats']['application/epub+zip']);
      }
      if (json['formats']['application/x-mobipocket-ebook'] != null) {
        downloads.add(json['formats']['application/x-mobipocket-ebook']);
      }
      if (json['formats']['text/plain'] != null) {
        downloads.add(json['formats']['text/plain']);
      }
    }

    return Book(
      id: json['id'],
      title: decodedTitle,
      author: authorName,
      coverUrl: cover,
      downloadUrls: downloads,
    );
  }
}