import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildSearchSection(),
            _buildFormatsBanner(),
            _buildFilters(),
            _buildBooksList(),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF1E293B)),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 8),
            const Text(
              'Request a Book',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search books...',
              border: InputBorder.none,
              icon: Icon(LucideIcons.search, color: Color(0xFF64748B)),
              hintStyle: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatsBanner() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF004D40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.bookOpen, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available in Multiple Formats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                    Text(
                      'Request any book in audio, Braille, large print, or e-book format.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      'All Formats',
      'Audio Book',
      'Braille',
      'Large Print',
      'E-Book',
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final isFirst = index == 0;
              return Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                child: Chip(
                  avatar: index == 1 ? const Icon(LucideIcons.headphones, size: 14) : 
                          index == 2 ? const Icon(LucideIcons.type, size: 14) : null,
                  label: Text(
                    filters[index],
                    style: TextStyle(
                      color: isFirst ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  backgroundColor: isFirst ? const Color(0xFF004D40) : Colors.white,
                  side: BorderSide(
                    color: isFirst ? const Color(0xFF004D40) : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBooksList() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildBookCard(
            'The Art of Possibility',
            'Rosamund Stone Zander',
            'Personal Growth',
            ['Audio Book', 'Braille', 'Large Print'],
          ),
          const SizedBox(height: 16),
          _buildBookCard(
            'A Still Small Voice',
            'Echo Bodine',
            'Spirituality',
            ['Audio Book', 'Large Print', 'E-Book'],
          ),
          const SizedBox(height: 16),
          _buildBookCard(
            'The Brain That Changes Itself',
            'Norman Doidge',
            'Neuroscience',
            ['Audio Book', 'Braille'],
          ),
        ]),
      ),
    );
  }

  Widget _buildBookCard(
    String title,
    String author,
    String category,
    List<String> formats,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.bookOpen, color: Color(0xFF065F46)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: formats
                .map(
                  (format) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          format == 'Audio Book' ? LucideIcons.headphones : 
                          format == 'Braille' ? LucideIcons.type : 
                          LucideIcons.book,
                          size: 12,
                          color: const Color(0xFF065F46),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          format,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF065F46),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D40),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Request Book',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
