import 'package:flutter/material.dart';

import 'package:famto_mini_booking/models/booking.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/service_category.dart';
import 'package:famto_mini_booking/screens/booking_screen.dart';
import 'package:famto_mini_booking/screens/confirmation_screen.dart';
import 'package:famto_mini_booking/screens/home_screen.dart';
import 'package:famto_mini_booking/screens/login_screen.dart';
import 'package:famto_mini_booking/screens/service_details_screen.dart';
import 'package:famto_mini_booking/screens/service_list_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const login = '/';
  static const home = '/home';
  static const services = '/services';
  static const details = '/service-details';
  static const booking = '/booking';
  static const confirmation = '/confirmation';
}
class AppRouter {
  AppRouter._();

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.login:
        return _page(settings, const LoginScreen());
      case AppRoutes.home:
        return _page(settings, const HomeScreen());
      case AppRoutes.services:
        if (args is ServiceCategory) {
          return _page(settings, ServiceListScreen(category: args));
        }
      case AppRoutes.details:
        if (args is Service) {
          return _page(settings, ServiceDetailsScreen(service: args));
        }
      case AppRoutes.booking:
        if (args is Service) {
          return _page(settings, BookingScreen(service: args));
        }
      case AppRoutes.confirmation:
        if (args is Booking) {
          return _page(settings, ConfirmationScreen(booking: args));
        }
    }
    return _page(settings, const _NotFoundScreen());
  }

  static Route<void> _page(RouteSettings settings, Widget child) =>
      MaterialPageRoute<void>(settings: settings, builder: (_) => child);
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This page could not be opened.'),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
