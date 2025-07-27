import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/data/service/news_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsService _newsService;

  final _newsSubject = BehaviorSubject<List<NewsModel>>.seeded([]);
  Stream<List<NewsModel>> get newsStream => _newsSubject.stream;

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

  Future<void> search(String query, {Map<String, dynamic>? params}) async {
    _isFirstSearch = false;
    if (_isLoading == true) return;
    _currentQuery = query;
    _currentPage = 1;
    _hasMore = true;
    _newsSubject.add([]);
    if (params != null) _params = params;
    await _loadPage();
  }

  Future<void> _loadPage() async {
    if (_currentPage >= _maxPage) return;
    _isLoading = true;
    final newsPage = await _newsService.fetchNews(
      query: _currentQuery,
      page: _currentPage,
      pageSize: _pageSize,
      params: _params,
    );
    if (newsPage.length < _pageSize) {
      _hasMore = false;
    }
    final currentList = _newsSubject.value;
    final updateList = [...currentList, ...newsPage];
    _newsSubject.add(updateList);
    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_currentPage >= _maxPage) return;
    if (_isLoading || !_hasMore) return;
    _currentPage = _currentPage + 1;
    await _loadPage();
  }

  void dispose() {
    _newsSubject.close();
  }
}
