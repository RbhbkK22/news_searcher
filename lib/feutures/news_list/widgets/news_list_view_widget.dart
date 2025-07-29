import 'package:flutter/material.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/widgets/news_list_tile.dart';

class NewsListViewWidget extends StatelessWidget {
  final Map<String, List<NewsModel>> groupedNews;
  final bool isLoading;
  final bool hasMore;
  final bool isFirstSearch;
  final ScrollController scrollController;

  const NewsListViewWidget({
    super.key,
    required this.groupedNews,
    required this.isLoading,
    required this.hasMore,
    required this.isFirstSearch,
    required this.scrollController,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isFirstSearch) {
      return Column(
        children: [
          SizedBox(height: 34),
          Text(
            'Введите ключевое слово и фильтры для поиска новостей',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (groupedNews.isEmpty) {
      return const Text('Новостей не найдено', maxLines: 2);
    }
    final dates = groupedNews.keys.toList();
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount: hasMore ? dates.length + 1 : dates.length,
        itemBuilder: (context, index) {
          if (index == groupedNews.length) {
            return Center(child: CircularProgressIndicator());
          }

          final date = dates[index];
          final newsForDate = groupedNews[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
              Divider(thickness: 3),

              ...newsForDate.map((news) => NewsListTile(newsModel: news)),
            ],
          );
        },
      ),
    );
  }
}
