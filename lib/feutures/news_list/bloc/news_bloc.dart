import 'dart:async';
import 'package:intl/intl.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/data/service/news_service.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsService _newsService;

  final _newsSubject = BehaviorSubject<List<NewsModel>>.seeded([]);
  Stream<Map<String, List<NewsModel>>> get groupedNewsStream =>
      _newsSubject.stream.map((newsList) {
        final Map<String, List<NewsModel>> grouped = {};

        for (var news in newsList) {
          final dateKey = DateFormat("yyyy-MM-dd").format(news.publishedAt);
          grouped.putIfAbsent(dateKey, () => []).add(news);
        }

        final sortedKeys = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        final sortedGrouped = <String, List<NewsModel>>{};
        for (var key in sortedKeys) {
          sortedGrouped[key] = grouped[key]!;
        }

        return sortedGrouped;
      });

  StreamSubscription<List<NewsModel>>? _currentSearchSubscription;
  StreamSubscription<List<NewsModel>>? _loadMoreSubscription;

  final int _pageSize = 25;
  final int _maxPage = 4;

  String _currentQuery = '';
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isFirstSearch = true;
  Map<String, dynamic> _params = {};

  NewsBloc(this._newsService);

  bool get hasMore => _hasMore;
  int get page => _currentPage;
  bool get isFirstSearch => _isFirstSearch;
  bool get isLoading => _isLoading;

  void search(String query, {Map<String, dynamic> params = const {}}) {
    _currentQuery = query;
    _params = params;
    _currentPage = 1;
    _hasMore = true;
    _isFirstSearch = true;
    _isLoading = true;
    _currentSearchSubscription?.cancel();

    // получаем стрим
    final newsStream = _newsService.fetchNews(
      query: query,
      params: params,
      page: _currentPage,
      pageSize: _pageSize,
    );
    _isFirstSearch = false;
    _currentSearchSubscription = newsStream.listen(
      (newsList) {
        _newsSubject.add(newsList);
        _isLoading = false;
      },
      onError: (e) {
        _newsSubject.addError(e);
      },
    );
  }

  void loadMore() {
    if (_isLoading || !_hasMore || _currentPage >= _maxPage) {
      return;
    }

    _isLoading = true;
    _currentPage++;

    final moreNewsStream = _newsService.fetchNews(
      query: _currentQuery,
      params: _params,
      page: _currentPage,
      pageSize: _pageSize,
    );

    final currentNews = _newsSubject.value;
    _loadMoreSubscription?.cancel();

    _loadMoreSubscription = moreNewsStream.listen(
      (newsList) {
        final updateList = [...currentNews, ...newsList];
        _newsSubject.add(updateList);

        _isLoading = false;
        if (newsList.length < _pageSize || _currentPage >= _maxPage) {
          _hasMore = false;
        }
      },
      onError: (e) {
        _newsSubject.addError(e);
        _isLoading = false;
      },
    );
  }

  void dispose() {
    _currentSearchSubscription?.cancel();
    _loadMoreSubscription?.cancel();
    _newsSubject.close();
  }
}
