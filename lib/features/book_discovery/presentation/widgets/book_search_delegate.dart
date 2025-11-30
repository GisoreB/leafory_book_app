import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/app_colors.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_search/book_search_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/widgets/search_results_view.dart';

class BookSearchDelegate extends SearchDelegate<Book?> {
  BookSearchDelegate({required this.bookSearchBloc}) {
    _scrollController.addListener(_onScroll);
  }

  final BookSearchBloc bookSearchBloc;
  final ScrollController _scrollController = ScrollController();

  String _lastDispatchedQuery = '';

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (!_isBottom) {
      return;
    }

    final BookSearchState currentState = bookSearchBloc.state;
    if (currentState is BookSearchLoaded && !currentState.hasReachedMax) {
      bookSearchBloc.add(SearchBooks(query));
    }
  }

  void _dispatchSearchEvent() {
    if (query == _lastDispatchedQuery) {
      return;
    }

    _lastDispatchedQuery = query;
    bookSearchBloc.add(SearchBooks(query));
  }

  void _clearQuery() {
    query = '';
    _lastDispatchedQuery = '';
    bookSearchBloc.add(const SearchBooks(''));
  }

  @override
  void close(BuildContext context, Book? result) {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.close(context, result);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: _clearQuery, icon: const Icon(Icons.clear_rounded), tooltip: 'Clear')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _dispatchSearchEvent();
    return SearchResultsView(scrollController: _scrollController);
  }

  @override
  Widget buildResults(BuildContext context) {
    _dispatchSearchEvent();
    return SearchResultsView(scrollController: _scrollController);
  }

  @override
  String? get searchFieldLabel => 'Search your favorite book';

  @override
  TextStyle? get searchFieldStyle => GoogleFonts.lato(color: AppColors.textPrimary);

  @override
  ThemeData appBarTheme(BuildContext context) => context.themeData.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
      hintStyle: context.textTheme.bodyMedium?.copyWith(color: context.customColorTheme.textSecondary),
      errorStyle: context.textTheme.bodyMedium?.copyWith(color: context.customColorTheme.error),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BorderRadiuses.regular),
        borderSide: BorderSide(color: context.customColorTheme.primaryLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BorderRadiuses.regular),
        borderSide: BorderSide(color: context.customColorTheme.primaryLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BorderRadiuses.regular),
        borderSide: BorderSide(color: context.customColorTheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BorderRadiuses.regular),
        borderSide: BorderSide(color: context.customColorTheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BorderRadiuses.regular),
        borderSide: BorderSide(color: context.customColorTheme.error),
      ),
    ),
  );
}
