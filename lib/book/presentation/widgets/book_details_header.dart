// lib/book/presentation/widgets/book_details_header.dart
import 'package:flutter/material.dart';

class BookDetailsHeader extends StatelessWidget {
  final String title;
  final String author;

  const BookDetailsHeader({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'by $author',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'NotoSans',
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}