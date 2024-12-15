// lib/book/presentation/widgets/download_options_list.dart
import 'package:flutter/material.dart';

class DownloadOptionsList extends StatelessWidget {
  final List<String> downloadUrls;
  final Function(String) onDownloadTap;

  const DownloadOptionsList({
    super.key,
    required this.downloadUrls,
    required this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    if (downloadUrls.isEmpty) {
      return const Text('No download options available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: downloadUrls.length,
      itemBuilder: (context, index) {
        final url = downloadUrls[index];
        String format = 'Unknown';
        if (url.contains('epub')) {
          format = 'EPUB';
        } else if (url.contains('mobi')) {
          format = 'MOBI';
        } else if (url.contains('txt')) {
          format = 'Text';
        }
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.download),
            title: Text(
              'Download $format version',
              style: const TextStyle(
                fontFamily: 'NotoSans',
              ),
            ),
            onTap: () => onDownloadTap(url),
          ),
        );
      },
    );
  }
}