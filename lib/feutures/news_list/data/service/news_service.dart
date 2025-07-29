import 'package:news_app/core/config/config.dart';
import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';

class NewsService {
  final DioClient dioClient;

  NewsService() : dioClient = DioClient(baseUrl: 'https://newsapi.org/v2');

  Stream<List<NewsModel>> fetchNews({
    required String query,
    required Map<String, dynamic> params,
    int page = 1,
    int pageSize = 25,
  }) {
    return Stream.fromFuture(
      dioClient
          .get(
            '/everything',
            queryParameters: {
              'q': query,
              ...params,
              'pageSize': pageSize,
              'page': page,
              'sortBy': 'publishedAt',
              'apiKey': config.apiKey,
            },
          )
          .then((response) {
            final data = response.data['articles'] as List;
            return data.map((json) => NewsModel.fromJson(json)).toList();
          }),
    );
  }
}
