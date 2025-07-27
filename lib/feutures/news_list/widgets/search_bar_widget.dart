import 'package:flutter/material.dart';
import 'package:news_app/feutures/news_list/widgets/search_text_field.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SearchTextField(controller: searchController)),
        IconButton(onPressed: onSearch, icon: Icon(Icons.search)),
      ],
    );
  }
}
