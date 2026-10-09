import 'package:flutter/foundation.dart';

import 'package:famto_mini_booking/data/service_repository.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/service_category.dart';
import 'package:famto_mini_booking/providers/async_state.dart';

/// Owns the browsing side of the app: categories and per-category services.
class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repository);

  final ServiceRepository _repository;

  AsyncState<List<ServiceCategory>> _categories =
      const AsyncState<List<ServiceCategory>>.loading();
  final Map<String, AsyncState<List<Service>>> _services = {};
  final Map<String, ServiceCategory> _categoryIndex = {};

  AsyncState<List<ServiceCategory>> get categories => _categories;

  AsyncState<List<Service>> servicesFor(String categoryId) =>
      _services[categoryId] ?? const AsyncState<List<Service>>.loading();

  ServiceCategory? categoryById(String id) => _categoryIndex[id];

  bool get simulateError => _repository.simulateError;

  void setSimulateError(bool value) {
    _repository.simulateError = value;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = const AsyncState<List<ServiceCategory>>.loading();
    notifyListeners();
    try {
      final data = await _repository.fetchCategories();
      for (final c in data) {
        _categoryIndex[c.id] = c;
      }
      _categories = data.isEmpty
          ? const AsyncState<List<ServiceCategory>>.empty()
          : AsyncState<List<ServiceCategory>>.loaded(data);
    } on ServiceException catch (e) {
      _categories = AsyncState<List<ServiceCategory>>.error(e.message);
    }
    notifyListeners();
  }

  /// Loads services once per category; pass [force] to retry/refresh.
  Future<void> loadServices(String categoryId, {bool force = false}) async {
    final current = _services[categoryId]?.status;
    if (!force &&
        (current == LoadStatus.loaded || current == LoadStatus.empty)) {
      return;
    }
    _services[categoryId] = const AsyncState<List<Service>>.loading();
    notifyListeners();
    try {
      final data = await _repository.fetchServices(categoryId);
      _services[categoryId] = data.isEmpty
          ? const AsyncState<List<Service>>.empty()
          : AsyncState<List<Service>>.loaded(data);
    } on ServiceException catch (e) {
      _services[categoryId] = AsyncState<List<Service>>.error(e.message);
    }
    notifyListeners();
  }
}
