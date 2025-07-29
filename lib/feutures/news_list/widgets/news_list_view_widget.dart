import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/widgets/news_list_tile.dart';

class NewsListViewWidget extends StatelessWidget {
  final List<NewsModel> newsList;
  final bool isLoading;
  final bool hasMore;
  final bool isFirstSearch;
  final ScrollController scrollController;

  const NewsListViewWidget({
    super.key,
    required this.newsList,
    required this.isLoading,
    required this.hasMore,
    required this.isFirstSearch,
    required this.scrollController,
  });

  Map<String, List<NewsModel>> groupNews() {
    final Map<String, List<NewsModel>> gruoped = {};

    for (var news in newsList) {
      final dateKey = DateFormat("yyyy-MM-dd").format(news.publishedAt);

      gruoped.putIfAbsent(dateKey, () => []).add(news);
    }
    return gruoped;
  }

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty && isLoading) {
      return const CircularProgressIndicator();
    }
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
    if (newsList.isEmpty) {
      return const Text('Новостей не найдено', maxLines: 2);
    }

    final gropedNews = groupNews();
    final sortedDates = gropedNews.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount: hasMore ? sortedDates.length + 1 : sortedDates.length,
        itemBuilder: (context, index) {
          if (index == sortedDates.length) {
            return Center(child: CircularProgressIndicator());
          }

          final date = sortedDates[index];
          final newsForDate = gropedNews[date]!;

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
