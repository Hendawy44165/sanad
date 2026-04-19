import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/news/data/models/news_item.dart';

/// Card widget to display a summary of a news item.
class NewsCard extends StatelessWidget {
  /// The news item to display.
  final NewsItem newsItem;

  /// Creates a [NewsCard].
  const NewsCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImage(), _buildContent(context)],
      ),
    );
  }

  Widget _buildImage() {
    if (newsItem.imageUrl == null) return const SizedBox.shrink();

    return Image.network(
      newsItem.imageUrl!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSummary(),
          const SizedBox(height: 16),
          const Divider(height: 1),
          _buildReadMoreButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryBadge(),
        Text(
          _formatDate(newsItem.publishedAt),
          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Text(
        newsItem.category.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.onSecondary,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      newsItem.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.3,
      ),
    );
  }

  Widget _buildSummary() {
    return Text(
      newsItem.summary ?? '',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textLight,
        height: 1.5,
      ),
    );
  }

  Widget _buildReadMoreButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/news/details', extra: newsItem);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: AlignmentDirectional.centerStart,
        foregroundColor: AppColors.primary,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Read Full Story'),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
