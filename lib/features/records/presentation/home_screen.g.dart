// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyStepsHash() => r'7053edd96830b6af7e288af71a27dbb6a6f2ba98';

/// See also [dailySteps].
@ProviderFor(dailySteps)
final dailyStepsProvider = AutoDisposeFutureProvider<int?>.internal(
  dailySteps,
  name: r'dailyStepsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dailyStepsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DailyStepsRef = AutoDisposeFutureProviderRef<int?>;
String _$homeControllerHash() => r'7d3756ee2a512a5fa5e0c97311dd189c2f22e8c3';

/// See also [HomeController].
@ProviderFor(HomeController)
final homeControllerProvider = AutoDisposeStreamNotifierProvider<HomeController,
    List<HealthRecord>>.internal(
  HomeController.new,
  name: r'homeControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeController = AutoDisposeStreamNotifier<List<HealthRecord>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
