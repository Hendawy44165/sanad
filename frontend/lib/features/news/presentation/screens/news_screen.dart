import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/news/data/models/news_item.dart';
import '../widgets/news_card.dart';

/// Screen that displays the latest news and updates.
class NewsScreen extends ConsumerWidget {
  /// Creates a [NewsScreen].
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(newsProvider.future),
        child: _buildBody(newsAsync),
      ),
    );
  }

  /// Builds the application bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Latest News'), centerTitle: false);
  }

  /// Builds the body content based on data state.
  Widget _buildBody(AsyncValue<List<NewsItem>> newsAsync) {
    return newsAsync.when(
      data: (news) => _buildNewsList(news),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  /// Builds the list of news items.
  Widget _buildNewsList(List<NewsItem> news) {
    if (news.isEmpty) {
      return const Center(child: Text('No news found'));
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: news.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return NewsCard(newsItem: news[index]);
      },
    );
  }
}
