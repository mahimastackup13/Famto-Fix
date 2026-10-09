import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/providers/async_state.dart';
import 'package:famto_mini_booking/providers/catalog_provider.dart';
import 'package:famto_mini_booking/widgets/category_card.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';
import 'package:famto_mini_booking/widgets/section_title.dart';
import 'package:famto_mini_booking/widgets/skeleton.dart';
import 'package:famto_mini_booking/widgets/state_views.dart';

const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 220,
  mainAxisExtent: 164,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final state = catalog.categories;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveCenter(
            child: RefreshIndicator(
              onRefresh: catalog.loadCategories,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: _HomeHeader()),
                  const SliverToBoxAdapter(
                    child: SectionTitle(
                      title: 'What do you need help with?',
                      subtitle: 'Choose a category to see available services',
                    ),
                  ),
                  ..._categorySlivers(context, catalog, state),
                  const SliverToBoxAdapter(child: _TrustStrip()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _categorySlivers(
    BuildContext context,
    CatalogProvider catalog,
    AsyncState<List<dynamic>> state,
  ) {
    switch (state.status) {
      case LoadStatus.loading:
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: _gridDelegate,
              delegate: SliverChildBuilderDelegate(
                (_, __) => const SkeletonBox(radius: 24),
                childCount: 6,
              ),
            ),
          ),
        ];
      case LoadStatus.error:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ErrorView(
                message: state.message ?? 'Unable to load categories.',
                onRetry: catalog.loadCategories,
              ),
            ),
          ),
        ];
      case LoadStatus.empty:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyView(
                title: 'No services yet',
                message:
                    'We are adding services in your area. Please check back soon.',
                actionLabel: 'Refresh',
                onAction: catalog.loadCategories,
              ),
            ),
          ),
        ];
      case LoadStatus.loaded:
        final categories = catalog.categories.data!;
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: _gridDelegate,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRoutes.services, arguments: category),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
        ];
    }
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 18, 8, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Famto Fixit Services',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Trusted home services,\nbooked in minutes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Verified professionals at your doorstep.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Demo options',
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (_) {
              catalog.setSimulateError(!catalog.simulateError);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      catalog.simulateError
                          ? 'Error simulation ON — pull down to refresh or open a category.'
                          : 'Error simulation OFF.',
                    ),
                  ),
                );
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem<String>(
                value: 'simulate_error',
                checked: catalog.simulateError,
                child: const Text('Simulate network error'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label) => Expanded(
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Row(
        children: [
          item(Icons.verified_user_outlined, 'Verified\nprofessionals'),
          item(Icons.sell_outlined, 'Upfront\npricing'),
          item(Icons.shield_outlined, '30-day\nservice warranty'),
        ],
      ),
    );
  }
}
