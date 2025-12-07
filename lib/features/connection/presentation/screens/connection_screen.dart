import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/connection_provider.dart';
import '../providers/connection_state.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  final _ipController = TextEditingController(text: AppConstants.defaultObdIp);
  final _portController = TextEditingController(
    text: AppConstants.defaultObdPort.toString(),
  );

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionProvider);
    final notifier = ref.read(connectionProvider.notifier);

    // Listen for successful connection to navigate
    ref.listen(connectionProvider, (previous, next) {
      if (next.status == ConnectionStatus.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connected Successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate to Dashboard after short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) context.go('/dashboard');
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Connect to Vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.directions_car_filled_outlined,
              size: 100,
              color: connectionState.status == ConnectionStatus.connected
                  ? AppColors.success
                  : AppColors.primary,
            ),
            const SizedBox(height: 32),
            if (connectionState.status == ConnectionStatus.error)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: Text(
                  connectionState.errorMessage ?? 'Unknown Error',
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'IP Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wifi),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.power_input),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: connectionState.status == ConnectionStatus.connecting
                  ? null
                  : () {
                      notifier.connect(
                        host: _ipController.text,
                        port:
                            int.tryParse(_portController.text) ??
                            AppConstants.defaultObdPort,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: connectionState.status == ConnectionStatus.connecting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'CONNECT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            if (connectionState.status == ConnectionStatus.connected)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/dashboard');
                  },
                  child: const Text('Continue to Dashboard'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
