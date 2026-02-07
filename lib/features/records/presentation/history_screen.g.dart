// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyControllerHash() => r'e219b6576b5a5763c01d6d534392e18875fb6b14';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$HistoryController
    extends BuildlessAutoDisposeStreamNotifier<List<HealthRecord>> {
  late final DateTime date;

  Stream<List<HealthRecord>> build(
    DateTime date,
  );
}

/// See also [HistoryController].
@ProviderFor(HistoryController)
const historyControllerProvider = HistoryControllerFamily();

/// See also [HistoryController].
class HistoryControllerFamily extends Family<AsyncValue<List<HealthRecord>>> {
  /// See also [HistoryController].
  const HistoryControllerFamily();

  /// See also [HistoryController].
  HistoryControllerProvider call(
    DateTime date,
  ) {
    return HistoryControllerProvider(
      date,
    );
  }

  @override
  HistoryControllerProvider getProviderOverride(
    covariant HistoryControllerProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'historyControllerProvider';
}

/// See also [HistoryController].
class HistoryControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    HistoryController, List<HealthRecord>> {
  /// See also [HistoryController].
  HistoryControllerProvider(
    DateTime date,
  ) : this._internal(
          () => HistoryController()..date = date,
          from: historyControllerProvider,
          name: r'historyControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$historyControllerHash,
          dependencies: HistoryControllerFamily._dependencies,
          allTransitiveDependencies:
              HistoryControllerFamily._allTransitiveDependencies,
          date: date,
        );

  HistoryControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Stream<List<HealthRecord>> runNotifierBuild(
    covariant HistoryController notifier,
  ) {
    return notifier.build(
      date,
    );
  }

  @override
  Override overrideWith(HistoryController Function() create) {
    return ProviderOverride(
      origin: this,
      override: HistoryControllerProvider._internal(
        () => create()..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<HistoryController,
      List<HealthRecord>> createElement() {
    return _HistoryControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryControllerProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HistoryControllerRef
    on AutoDisposeStreamNotifierProviderRef<List<HealthRecord>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _HistoryControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<HistoryController,
        List<HealthRecord>> with HistoryControllerRef {
  _HistoryControllerProviderElement(super.provider);

  @override
  DateTime get date => (origin as HistoryControllerProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
