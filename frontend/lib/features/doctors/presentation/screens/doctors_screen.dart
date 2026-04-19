import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/l10n/app_localizations.dart';

class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildSearchSection(context),
            _buildFilters(context),
            _buildDoctorsList(context),
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
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: Color(0xFF1E293B),
              ),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.findDoctor,
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

  Widget _buildSearchSection(BuildContext context) {
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
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchSpecialists,
              border: InputBorder.none,
              icon: const Icon(LucideIcons.search, color: Color(0xFF64748B)),
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.neurology,
      AppLocalizations.of(context)!.physical,
      AppLocalizations.of(context)!.occupational,
      AppLocalizations.of(context)!.speech,
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  label: Text(
                    filters[index],
                    style: TextStyle(
                      color: isFirst ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  backgroundColor: isFirst
                      ? const Color(0xFF004D40)
                      : Colors.white,
                  side: BorderSide(
                    color: isFirst
                        ? const Color(0xFF004D40)
                        : const Color(0xFFE2E8F0),
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

  Widget _buildDoctorsList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildDoctorCard(
            'Dr. Layla Khaled',
            AppLocalizations.of(context)!.neurologySpecialist,
            4.9,
            120,
            [
              AppLocalizations.of(context)!.wheelchairAccess,
              AppLocalizations.of(context)!.signLanguage,
              AppLocalizations.of(context)!.audioAids,
            ],
            context,
          ),
          const SizedBox(height: 16),
          _buildDoctorCard(
            'Dr. Omar Nasser',
            AppLocalizations.of(context)!.physicalTherapy,
            4.8,
            85,
            [
              AppLocalizations.of(context)!.wheelchairAccess,
              AppLocalizations.of(context)!.signLanguage,
            ],
            context,
          ),
          const SizedBox(height: 16),
          _buildDoctorCard(
            'Dr. Sarah Ahmed',
            AppLocalizations.of(context)!.occupationalTherapy,
            4.7,
            64,
            [
              AppLocalizations.of(context)!.wheelchairAccess,
              AppLocalizations.of(context)!.audioAids,
            ],
            context,
          ),
        ]),
      ),
    );
  }

  Widget _buildDoctorCard(
    String name,
    String specialty,
    double rating,
    int reviews,
    List<String> badges,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.stethoscope,
                  color: Color(0xFF065F46),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 18,
                            color: index < rating.floor()
                                ? Colors.amber
                                : Colors.grey[300],
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.reviews(reviews),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges
                .map(
                  (badge) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: Color(0xFF065F46),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 12,
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
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.calendar),
              label: Text(AppLocalizations.of(context)!.bookAppointment),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D40),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
