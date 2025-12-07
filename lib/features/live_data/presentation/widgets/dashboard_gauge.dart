import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardGauge extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color needleColor;

  const DashboardGauge({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    this.needleColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        SizedBox(
          height: 200,
          width: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: min,
                maximum: max,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.2,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: AppColors.gaugeBackground,
                ),
                majorTickStyle: const MajorTickStyle(
                  length: 6,
                  thickness: 2,
                  color: Colors.white54,
                ),
                minorTickStyle: const MinorTickStyle(
                  length: 3,
                  thickness: 1,
                  color: Colors.white24,
                ),
                axisLabelStyle: const GaugeTextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: value,
                    needleColor: needleColor,
                    enableAnimation: true,
                    animationDuration: 500,
                    knobStyle: const KnobStyle(color: Colors.white),
                  ),
                  RangePointer(
                    value: value,
                    width: 0.2,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: needleColor.withValues(alpha: 0.3),
                    enableAnimation: true,
                    animationDuration: 500,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
