// lib/book/presentation/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/book.dart';
import '../widgets/book_cover_image.dart';
import '../widgets/book_details_header.dart';
import '../widgets/download_options_list.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          style: const TextStyle(
            fontFamily: 'NotoSans',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverImage(imageUrl: book.coverUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookDetailsHeader(
                    title: book.title,
                    author: book.author,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Download Options',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  DownloadOptionsList(
                    downloadUrls: book.downloadUrls,
                    onDownloadTap: _launchURL,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
