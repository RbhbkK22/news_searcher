import 'package:flutter/material.dart';
import 'package:news_app/feutures/news_list/data/models/news_model.dart';
import 'package:news_app/feutures/news_list/data/service/news_service.dart';
import 'package:news_app/feutures/news_list/bloc/news_bloc.dart';
import 'package:news_app/feutures/news_list/widgets/filter_alert_dialog.dart';
import 'package:news_app/feutures/news_list/widgets/filter_button_widget.dart';
import 'package:news_app/feutures/news_list/widgets/news_list_view_widget.dart';
import 'package:news_app/feutures/news_list/widgets/search_bar_widget.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late final NewsBloc _bloc;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> params = {'language': null, 'from': null, 'to': null};

  void search() {
    final query = _searchController.text;
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Вы не ввели ключевое слово для поиска новостей'),
        ),
      );
    } else {
      _bloc.search(query);
    }
  }

  void searchWithParams() async {
    final query = _searchController.text;
    final result = await showDialog(
      context: context,
      builder: (context) {
        return FilterAlertDialog();
      },
    );
    if (result != null) {
      params = result;
      _bloc.search(query, params: params);
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = NewsBloc(NewsService());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _bloc.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //поле поиска и кнопка фильтров
            SearchBarWidget(
              searchController: _searchController,
              onSearch: search,
            ),
            // кнопка фильтров
            FilterButtonWidget(onPressed: searchWithParams),
            //список новостей
            StreamBuilder<List<NewsModel>>(
              stream: _bloc.newsStream,
              builder: (context, snapshot) {
                return NewsListViewWidget(
                  newsList: snapshot.data ?? [],
                  isLoading: _bloc.isLoading,
                  hasMore: _bloc.hasMore,
                  isFirstSearch: _bloc.isFirstSearch,
                  scrollController: _scrollController,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
