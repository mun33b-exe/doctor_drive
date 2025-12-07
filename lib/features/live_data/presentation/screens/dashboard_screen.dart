import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../connection/presentation/providers/connection_provider.dart';
import '../../../connection/presentation/providers/connection_state.dart';
import '../providers/live_data_providers.dart';
import '../widgets/dashboard_gauge.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Start polling when screen is active
    ref.watch(pollingControllerProvider);

    // Monitor connection state for dropouts
    ref.listen(connectionProvider, (previous, next) {
      if (next.status == ConnectionStatus.disconnected ||
          next.status == ConnectionStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection Lost: ${next.errorMessage ?? "Disconnected"}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        // Redirect back to connection screen
        if (context.mounted) context.go('/connection');
      }
    });

    final rpmAsync = ref.watch(rpmProvider);
    final speedAsync = ref.watch(speedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status Card (Optional placeholder)
            Card(
              color: AppColors.surfaceLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bluetooth_connected,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Connected to ELM327',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Gauges Row
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: [
                    DashboardGauge(
                      title: 'RPM',
                      value: rpmAsync.valueOrNull ?? 0,
                      min: 0,
                      max: 8000,
                      unit: 'rev/min',
                      needleColor: AppColors.primary,
                    ),
                    DashboardGauge(
                      title: 'SPEED',
                      value: speedAsync.valueOrNull ?? 0,
                      min: 0,
                      max: 220,
                      unit: 'km/h',
                      needleColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
