import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Fix this import - remove 'providers/' and use correct path
import 'package:roncafeapp_manager/services/sync_service.dart';

class SyncStatusWidget extends StatelessWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncService>(
      builder: (context, syncService, child) {
        return Tooltip(
          message: syncService.isSyncing
              ? 'Syncing...'
              : 'Last sync: ${syncService.lastSyncTime?.toLocal().toString() ?? 'Never'}',
          child: GestureDetector(
            onTap: () => _showSyncDialog(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  syncService.isSyncing
                      ? Icons.sync_rounded
                      : Icons.sync_alt_rounded,
                  color: syncService.syncError != null
                      ? Colors.red
                      : syncService.lastSyncTime != null
                      ? Colors.green
                      : Colors.grey,
                  size: 28,
                ),
                if (syncService.isSyncing)
                  const SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                if (syncService.syncedAppsCount > 0 && !syncService.isSyncing)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        syncService.syncedAppsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sync_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Text('Sync Options'),
          ],
        ),
        content: Consumer<SyncService>(
          builder: (context, syncService, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (syncService.isSyncing)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                if (syncService.syncError != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${syncService.syncError}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: const Text('Sync from Avalonia'),
                  subtitle: Text(
                    syncService.lastSyncTime != null
                        ? 'Last: ${syncService.lastSyncTime!.toLocal().toString()}'
                        : 'Never synced',
                  ),
                  onTap: syncService.isSyncing
                      ? null
                      : () async {
                          Navigator.pop(context);
                          await syncService.syncFromAvalonia();
                        },
                ),
                ListTile(
                  leading: const Icon(Icons.upload_rounded),
                  title: const Text('Sync to Avalonia'),
                  onTap: syncService.isSyncing
                      ? null
                      : () async {
                          Navigator.pop(context);
                          await syncService.syncToAvalonia();
                        },
                ),
                if (syncService.syncedAppsCount > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${syncService.syncedAppsCount} apps synced',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
