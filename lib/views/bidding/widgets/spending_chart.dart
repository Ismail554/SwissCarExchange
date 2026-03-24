import 'package:flutter/material.dart';
import 'package:rionydo/core/utils/app_colors.dart';

/// Renders a smooth curved line chart with a gradient fill.
///
/// [points]  — normalised (0–1) y-values; count should equal [xLabels] count.
/// [xLabels] — labels shown along the x-axis (e.g. Mon–Sun, W1–W4, Jan–Dec).
class SpendingChart extends StatelessWidget {
  final List<double> points;
  final List<String> xLabels;

  const SpendingChart({super.key, required this.points, required this.xLabels});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(points: points, xLabels: xLabels),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final List<String> xLabels;

  const _LineChartPainter({required this.points, required this.xLabels});

  static const double _labelAreaHeight = 16.0;
  static const double _labelFontSize = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final count = points.length;
    if (count < 2) return;

    // Reserve space at bottom for x-axis labels
    final chartHeight = size.height - _labelAreaHeight;

    final linePaint = Paint()
      ..color = AppColors.sceTeal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.sceTeal.withOpacity(0.35),
          AppColors.sceTeal.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < count; i++) {
      final x = size.width * i / (count - 1);
      final y = chartHeight * (1 - points[i]);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        final prevX = size.width * (i - 1) / (count - 1);
        final prevY = chartHeight * (1 - points[i - 1]);
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
        fillPath.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }

    // Close fill area to bottom
    fillPath.lineTo(size.width, chartHeight);
    fillPath.lineTo(0, chartHeight);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // --- Draw x-axis labels evenly across the full width ---
    final labelCount = xLabels.length;
    if (labelCount < 2) return;

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labelCount; i++) {
      tp.text = TextSpan(
        text: xLabels[i],
        style: const TextStyle(
          color: Color(0xFF848484),
          fontSize: _labelFontSize,
        ),
      );
      tp.layout();
      final x = size.width * i / (labelCount - 1) - tp.width / 2;
      tp.paint(
        canvas,
        Offset(x.clamp(0, size.width - tp.width), chartHeight + 3),
      );
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.points != points || old.xLabels != xLabels;
}
