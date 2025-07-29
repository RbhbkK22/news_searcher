import 'dart:async';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/data/service/news_service.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsService _newsService;

  final _newsSubject = BehaviorSubject<List<NewsModel>>.seeded([]);
  Stream<List<NewsModel>> get newsStream => _newsSubject.stream;

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
        final sorted = [...newsList]
          ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        _newsSubject.add(sorted);
        _isLoading = false;
      },
      onError: (e) {
        _newsSubject.addError(e);
      },
    );
  }

  void loadMore() {
    if (_isLoading || !_hasMore || _currentPage >= _maxPage) {
      _hasMore = false;
      return;
    }
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
        final updateList = [...currentNews, ...newsList]
          ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        _newsSubject.add(updateList);
      },
      onError: (e) {
        _newsSubject.addError(e);
      },
    );
  }

  void dispose() {
    _currentSearchSubscription?.cancel();
    _loadMoreSubscription?.cancel();
    _newsSubject.close();
  }
}
