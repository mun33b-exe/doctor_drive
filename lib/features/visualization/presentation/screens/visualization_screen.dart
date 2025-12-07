import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../diagnostics/data/models/dtc_model.dart';
import '../../../diagnostics/presentation/providers/dtc_providers.dart';
import '../../data/services/fault_localization_service.dart';

class VisualizationScreen extends ConsumerStatefulWidget {
  const VisualizationScreen({super.key});

  @override
  ConsumerState<VisualizationScreen> createState() =>
      _VisualizationScreenState();
}

class _VisualizationScreenState extends ConsumerState<VisualizationScreen> {
  // Use late or nullable if needed, but instant init is fine
  final Flutter3DController _controller = Flutter3DController();

  String _statusMessage = 'Loading 3D Model...';
  bool _modelLoaded = false;
  List<DtcModel> _dtcList = [];

  @override
  void initState() {
    super.initState();
    // Schedule initial logic after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Simulate 3D model load completion
      setState(() {
        _modelLoaded = true;
        _statusMessage = 'Interactive 3D View';
      });

      // Trigger fault focus
      _safeAutoZoomToFault();
    });
  }

  Future<void> _safeAutoZoomToFault() async {
    if (!mounted) return;

    List<DtcModel> dtcs = [];
    try {
      // Safely read the provider.
      // If the repo throws, we catch it here.
      dtcs = await ref.read(storedDtcProvider.future);
    } catch (e) {
      // Error handling: Force empty list to trigger Demo Mode
      debugPrint('VisualizationScreen: Error fetching DTCs: $e');
      dtcs = [];
    }

    // Force Demo Mode if no DTCs found (disconnected or empty)
    if (dtcs.isEmpty) {
      dtcs = [
        const DtcModel(
          code: 'P0300',
          description: 'Random/Multiple Cylinder Misfire Detected',
          system: 'Powertrain',
          severity: 'High',
        ),
        const DtcModel(
          code: 'C0200',
          description: 'ABS Wheel Speed Sensor',
          system: 'Chassis',
          severity: 'Medium',
        ),
      ];

      if (mounted) {
        setState(() {
          _statusMessage = 'Demo Mode: Simulating Faults';
        });
      }
    }

    if (!mounted) return;

    // Update local state
    setState(() {
      _dtcList = dtcs;
    });

    // Auto-focus logic
    if (dtcs.isNotEmpty) {
      final firstFault = dtcs.first;
      final orbit = FaultLocalizationService.getCameraOrbitForDtc(firstFault);

      if (orbit != null) {
        try {
          _applyCameraOrbit(orbit);
          if (mounted) {
            setState(() {
              if (!_statusMessage.startsWith('Demo')) {
                _statusMessage =
                    'Focused on: ${FaultLocalizationService.getPartDescription(firstFault)}';
              }
            });
          }
        } catch (e) {
          debugPrint('Error applying camera orbit: $e');
        }
      }
    }
  }

  void _applyCameraOrbit(String orbitObj) {
    if (!mounted) return;
    try {
      final parts = orbitObj.split(' ');
      if (parts.length >= 3) {
        final theta = double.tryParse(parts[0].replaceAll('deg', '')) ?? 0.0;
        final phi = double.tryParse(parts[1].replaceAll('deg', '')) ?? 0.0;
        final radius = double.tryParse(parts[2].replaceAll('m', '')) ?? 2.0;
        _controller.setCameraOrbit(theta, phi, radius);
      }
    } catch (e) {
      debugPrint('Camera orbit error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const modelSource = 'assets/3d/car.glb';

    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Fault Visualization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_weak),
            onPressed: () {
              try {
                _controller.resetCameraOrbit();
                setState(() {
                  _statusMessage = 'Reset View';
                });
              } catch (_) {}
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
                  // Add validation if supported by package in future
                ),
                if (!_modelLoaded)
                  const Center(child: CircularProgressIndicator()),

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

          // Fault Selector
          Container(
            height: 120,
            color: AppColors.surface,
            child: _dtcList.isEmpty
                ? const Center(child: Text('No Faults Detected'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dtcList.length,
                    itemBuilder: (context, index) {
                      final dtc = _dtcList[index];
                      return GestureDetector(
                        onTap: () {
                          final orbit =
                              FaultLocalizationService.getCameraOrbitForDtc(
                                dtc,
                              );
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
                  ),
          ),
        ],
      ),
    );
  }
}
