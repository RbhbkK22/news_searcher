import 'package:news_app/core/config/config.dart';
import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';

class NewsService {
  final DioClient dioClient;

  NewsService() : dioClient = DioClient(baseUrl: 'https://newsapi.org/v2');

  Future<List<NewsModel>> fetchNews({
    required String query,
    required Map<String, dynamic> params,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final response = await dioClient.get(
        '/everything',
        queryParameters: {
          'q': query,
          ...params,
          'pageSize': pageSize,
          'page': page,
          'sortBy': 'publishedAt',
          'apiKey': config.apiKey,
        },
      );

      final data = response.data['articles'] as List;
      final articles = data.map((data) => NewsModel.fromJson(data)).toList();
      return articles;
    } catch (e) {
      throw Exception(e);
    }
  }
}
