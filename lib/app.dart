import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/core/app_config.dart';
import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/data/service_repository.dart';
import 'package:famto_mini_booking/providers/booking_provider.dart';
import 'package:famto_mini_booking/providers/catalog_provider.dart';

/// Root widget: wires dependencies (repository -> providers) and the router.
class FamtoApp extends StatelessWidget {
  const FamtoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServiceRepository>(create: (_) => ServiceRepository()),
        ChangeNotifierProvider<CatalogProvider>(
          create: (c) =>
              CatalogProvider(c.read<ServiceRepository>())..loadCategories(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (c) => BookingProvider(c.read<ServiceRepository>()),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
