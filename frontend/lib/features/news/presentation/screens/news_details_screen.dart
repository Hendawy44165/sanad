import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/news/data/models/news_item.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailsScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetaInfo(),
                  const SizedBox(height: 16),
                  _buildTitle(),
                  const SizedBox(height: 12),
                  _buildSource(),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),
                  _buildContent(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (newsItem.imageUrl != null)
              Image.network(
                newsItem.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.surface),
              )
            else
              Container(color: AppColors.primary),
            // Gradient Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            newsItem.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSecondary,
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 14,
              color: AppColors.textLight,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDate(newsItem.publishedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      newsItem.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.3,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSource() {
    if (newsItem.source == null) return const SizedBox.shrink();

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.article, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          'Source: ${newsItem.source}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      newsItem.content ?? newsItem.summary ?? 'No content available.',
      style: const TextStyle(fontSize: 16, color: AppColors.text, height: 1.8),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
