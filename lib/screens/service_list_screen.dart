import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/service_category.dart';
import 'package:famto_mini_booking/providers/async_state.dart';
import 'package:famto_mini_booking/providers/catalog_provider.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';
import 'package:famto_mini_booking/widgets/service_card.dart';
import 'package:famto_mini_booking/widgets/skeleton.dart';
import 'package:famto_mini_booking/widgets/state_views.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key, required this.category});

  final ServiceCategory category;

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CatalogProvider>().loadServices(widget.category.id);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final state = catalog.servicesFor(widget.category.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: ResponsiveCenter(
        child: Column(
          children: [
            if (state.status == LoadStatus.loaded) _searchField(),
            Expanded(child: _body(context, catalog, state)),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (value) => setState(() => _query = value.trim()),
        decoration: InputDecoration(
          hintText: 'Search in ${widget.category.name}',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    CatalogProvider catalog,
    AsyncState<List<Service>> state,
  ) {
    switch (state.status) {
      case LoadStatus.loading:
        return const ServiceListSkeleton();
      case LoadStatus.error:
        return ErrorView(
          message: state.message ?? 'Unable to load services.',
          onRetry: () => catalog.loadServices(widget.category.id, force: true),
        );
      case LoadStatus.empty:
        return EmptyView(
          icon: widget.category.icon,
          title: 'Coming soon',
          message:
              '${widget.category.name} services are not available in your area yet. '
              'Please explore another category.',
          actionLabel: 'Browse categories',
          onAction: () => Navigator.of(context).maybePop(),
        );
      case LoadStatus.loaded:
        final all = state.data!;
        final q = _query.toLowerCase();
        final services = q.isEmpty
            ? all
            : all.where((s) => s.name.toLowerCase().contains(q)).toList();
        if (services.isEmpty) {
          return EmptyView(
            icon: Icons.search_off,
            title: 'No matching services',
            message: 'We could not find "$_query". Try a different keyword.',
            actionLabel: 'Clear search',
            onAction: _clearSearch,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: services.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${services.length} ${services.length == 1 ? 'service' : 'services'} available',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            final service = services[index - 1];
            return ServiceCard(
              service: service,
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.details, arguments: service),
            );
          },
        );
    }
  }
}
