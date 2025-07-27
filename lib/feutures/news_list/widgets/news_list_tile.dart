import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsListTile extends StatefulWidget {
  final NewsModel newsModel;

  const NewsListTile({super.key, required this.newsModel});

  @override
  State<NewsListTile> createState() => _NewsListTileState();
}

class _NewsListTileState extends State<NewsListTile> {
  bool _imageLoaded = true;
  Future<void> openUrl() async {
    print(widget.newsModel.urlToImage);
    final uri = Uri.parse(widget.newsModel.url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${difference.inDays} дн назад';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.newsModel.urlToImage.isNotEmpty;

    return InkWell(
      onTap: openUrl,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.newsModel.urlToImage,

                  height: _imageLoaded ? 80 : 0,
                  width: _imageLoaded ? 80 : 0,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _imageLoaded = false;
                        });
                      }
                    });

                    return SizedBox.shrink();
                  },
                ),
              ),
            if (hasImage && _imageLoaded) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.newsModel.sourceName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.newsModel.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.newsModel.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      widget.newsModel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    formatTime(widget.newsModel.publishedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
