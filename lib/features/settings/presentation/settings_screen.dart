import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sdd_health_record/core/database/isar_provider.dart';
import 'package:sdd_health_record/features/records/repository/health_record_repository.dart';

part 'settings_screen.g.dart';

@riverpod
Future<PackageInfo> packageInfo(PackageInfoRef ref) {
  return PackageInfo.fromPlatform();
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('About App'),
            subtitle: packageInfoAsync.when(
              data: (info) =>
                  Text('Version ${info.version} (Build ${info.buildNumber})'),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Error loading version'),
            ),
            leading: const Icon(Icons.info),
          ),
          const Divider(),
          ListTile(
            title: const Text('Delete All Data'),
            subtitle: const Text('Caution: This cannot be undone.'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete All Data?'),
                  content: const Text(
                    'Are you sure you want to delete all health records? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final isar = await ref.read(isarProvider.future);
                await isar.writeTxn(() async {
                  await isar.clear();
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data deleted.')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
