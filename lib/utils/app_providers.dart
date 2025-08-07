import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProviders {
  AppProviders._();

  static final List _neglectProviders = [];

  static final List<ProviderBase> _allProviders = <ProviderBase>[];

  static void addProvider(ProviderBase provider) {
    if (_neglectProviders.contains(provider.runtimeType)) {
      return;
    }
    _allProviders.add(provider);
  }

  static Future<void> invalidateAllProviders(WidgetRef ref) async {
    for (var provider in _allProviders) {
      ref.invalidate(provider);
    }
    _allProviders.clear();
  }
}

class AppProviderObservers extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    AppProviders.addProvider(provider);
    super.didAddProvider(provider, value, container);
  }
}
