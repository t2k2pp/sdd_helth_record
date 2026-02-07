import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:sdd_health_record/features/records/presentation/home_screen.dart';
import 'package:sdd_health_record/features/records/presentation/input_record_screen.dart';
import 'package:sdd_health_record/features/records/presentation/history_screen.dart';
import 'package:sdd_health_record/features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/add',
        builder: (context, state) => const InputRecordScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
