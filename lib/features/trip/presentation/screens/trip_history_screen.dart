import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/trip_providers.dart';

class TripHistoryScreen extends ConsumerWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Basic placeholder list for now since we don't have local DB persistence for trips yet
    final eventsAsync = ref.watch(drivingEventProvider);
    final isDriving = ref.watch(tripControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        actions: [
          if (isDriving)
            IconButton(
              icon: const Icon(Icons.stop_circle, color: AppColors.error),
              onPressed: () =>
                  ref.read(tripControllerProvider.notifier).stopTrip(),
            )
          else
            IconButton(
              icon: const Icon(Icons.play_circle, color: AppColors.success),
              onPressed: () =>
                  ref.read(tripControllerProvider.notifier).startTrip(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Status Banner
          Container(
            width: double.infinity,
            color: isDriving
                ? AppColors.success.withValues(alpha: 0.1)
                : Colors.transparent,
            padding: const EdgeInsets.all(12),
            child: Text(
              isDriving
                  ? 'Trip in Progress... Monitoring'
                  : 'Ready to start trip',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDriving ? AppColors.success : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: eventsAsync.when(
              data: (event) {
                // This stream yield single events.
                // A real history screen needs a list.
                // For demo, we just show the LAST detected event here.
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Last Event Detected:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        _getEventIcon(event.type),
                        size: 64,
                        color: AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.type,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(event.timestamp.toLocal().toString()),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: Text('Waiting for events...')),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String type) {
    if (type.contains('BRAKE')) return Icons.priority_high;
    if (type.contains('ACCEL')) return Icons.speed;
    return Icons.warning;
  }
}
