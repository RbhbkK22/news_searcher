class NewsModel {
  final String title;
  final String sourceName;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String description;

  NewsModel({
    required this.title,
    required this.sourceName,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.description,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'без названия',
      sourceName: json['source']['name'] ?? 'без источника',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      description: json['description'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
}
