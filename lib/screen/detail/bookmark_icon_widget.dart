import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourism_app/data/model/tourism.dart';
import 'package:tourism_app/provider/bookmark/local_database_provider.dart';
import 'package:tourism_app/provider/detail/bookmark_icon_provider.dart';

class BookmarkIconWidget extends StatefulWidget {
  final Tourism tourism;
  const BookmarkIconWidget({
    super.key,
    required this.tourism,
  });

  @override
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
  @override
  void initState() {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final bookmarkIconProvider = context.read<BookmarkIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadTourismById(widget.tourism.id);
      final value = localDatabaseProvider.checkItemBookmark(widget.tourism.id);

      bookmarkIconProvider.isBookmarked = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final bookmarkIconProvider = context.read<BookmarkIconProvider>();
        final isBookmarked = bookmarkIconProvider.isBookmarked;

        if (!isBookmarked) {
          await localDatabaseProvider.saveTourism(widget.tourism);
        } else {
          await localDatabaseProvider.removeTourismById(widget.tourism.id);
        }

        bookmarkIconProvider.isBookmarked = !isBookmarked;
        localDatabaseProvider.loadAllTourism();
      },
      icon: Icon(
        context.watch<BookmarkIconProvider>().isBookmarked
          ? Icons.bookmark
          : Icons.bookmark_outline,
      ),
    );
  }
}
