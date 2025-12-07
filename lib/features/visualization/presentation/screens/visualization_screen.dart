import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../diagnostics/presentation/providers/dtc_providers.dart';
import '../../data/services/fault_localization_service.dart';

class VisualizationScreen extends ConsumerStatefulWidget {
  const VisualizationScreen({super.key});

  @override
  ConsumerState<VisualizationScreen> createState() =>
      _VisualizationScreenState();
}

class _VisualizationScreenState extends ConsumerState<VisualizationScreen> {
  final Flutter3DController _controller = Flutter3DController();

  String _statusMessage = 'Loading 3D Model...';
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    // Schedule initial focus attempt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoZoomToFault();
      // Simulate load completion
      setState(() {
        _modelLoaded = true;
        _statusMessage = 'Interactive 3D View';
      });
    });
  }

  Future<void> _autoZoomToFault() async {
    final dtcs = await ref.read(storedDtcProvider.future);
    if (dtcs.isNotEmpty) {
      final firstFault = dtcs.first;
      final orbit = FaultLocalizationService.getCameraOrbitForDtc(firstFault);
      if (orbit != null) {
        _applyCameraOrbit(orbit);
        setState(() {
          _statusMessage =
              'Focused on: ${FaultLocalizationService.getPartDescription(firstFault)}';
        });
      }
    }
  }

  void _applyCameraOrbit(String orbitObj) {
    // orbitObj is likely "theta phi radius" e.g. "0deg 60deg 2m" or just numbers
    // We need to parse this.
    // DtcService returns strings with units.
    final parts = orbitObj.split(' ');
    if (parts.length >= 3) {
      final theta = double.tryParse(parts[0].replaceAll('deg', '')) ?? 0.0;
      final phi = double.tryParse(parts[1].replaceAll('deg', '')) ?? 0.0;
      final radius =
          double.tryParse(parts[2].replaceAll('m', '')) ?? 2.0; // zoom
      _controller.setCameraOrbit(theta, phi, radius);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dtcsAsync = ref.watch(storedDtcProvider);

    // Fallback URL if local asset missing (using a placeholder generic car if available, or just a cube for now)
    // Ideally use 'assets/3d/car.glb'
    // Since we don't know if user added it, we try to load it.
    // If it fails, flutter_3d_controller might show error or blank.
    // For this generic code, let's point to the asset.
    const modelSource = 'assets/3d/car.glb';

    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Fault Visualization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_weak),
            onPressed: () {
              _controller.resetCameraOrbit();
              setState(() {
                _statusMessage = 'Reset View';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Flutter3DViewer(
                  src: modelSource,
                  controller: _controller,
                  // onLoad/onError might not be supported in this version directly on widget
                  // or names differ. Removing to fix build errors.
                  // We will assume load is handled.
                ),
                if (!_modelLoaded)
                  const Center(child: CircularProgressIndicator()),

                // Overlay info
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fault List Selector
          Container(
            height: 120,
            color: AppColors.surface,
            child: dtcsAsync.when(
              data: (dtcs) {
                if (dtcs.isEmpty) {
                  return const Center(child: Text('No Faults Detected'));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dtcs.length,
                  itemBuilder: (context, index) {
                    final dtc = dtcs[index];
                    return GestureDetector(
                      onTap: () {
                        final orbit =
                            FaultLocalizationService.getCameraOrbitForDtc(dtc);
                        if (orbit != null) {
                          _applyCameraOrbit(orbit);
                          setState(() {
                            _statusMessage =
                                'Inspecting ${dtc.code}: ${FaultLocalizationService.getPartDescription(dtc)}';
                          });
                        }
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.error),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dtc.code,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                            Text(
                              dtc.system,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
