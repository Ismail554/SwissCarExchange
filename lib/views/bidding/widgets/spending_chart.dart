import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/models/analytics/spending_analytics_response.dart';

/// Redesigned spending chart with CHF y-axis, formatted x-axis labels,
/// and horizontal scroll for dense periods (30D = 30 points).
class SpendingChart extends StatelessWidget {
  final List<SpendingTrend> trends;
  final String period; // '7D' | '30D' | '90D' | '1Y'

  const SpendingChart({
    super.key,
    required this.trends,
    required this.period,
  });

  static const double _yAxisWidth = 58.0;
  static const double _xLabelHeight = 20.0;
  static const double _pointWidth = 36.0; // px per point when scrollable

  bool get _isDayLabel => period == '7D' || period == '30D';
  bool get _shouldScroll => trends.length > 14;

  // ── Label formatters ─────────────────────────────────────────────────────

  String _formatX(String raw) {
    if (_isDayLabel) {
      try {
        final dt = DateTime.parse(raw);
        const mo = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        // 7D → "May 7", 30D → "07" (compact for scroll)
        return period == '7D'
            ? '${mo[dt.month - 1]} ${dt.day}'
            : '${dt.day}'.padLeft(2, '0');
      } catch (_) {
        return raw;
      }
    } else {
      // "Mar 2026" → "Mar" (90D) or "Mar'26" (1Y)
      final parts = raw.split(' ');
      if (parts.length >= 2) {
        return period == '1Y'
            ? "${parts[0]}'${parts[1].substring(2)}"
            : parts[0];
      }
      return raw;
    }
  }

  String _formatY(double v) {
    if (v == 0) return '0';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) {
      final k = v / 1000;
      return '${k % 1 == 0 ? k.toStringAsFixed(0) : k.toStringAsFixed(1)}k';
    }
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty || trends.length < 2) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      );
    }

    final amounts =
        trends.map((t) => double.tryParse(t.amount) ?? 0.0).toList();
    final maxAmt = amounts.reduce((a, b) => a > b ? a : b);
    final normalised = maxAmt > 0
        ? amounts.map((v) => v / maxAmt).toList()
        : List.filled(amounts.length, 0.0);
    final xLabels = trends.map((t) => _formatX(t.label)).toList();

    // Y-axis ticks: 4 levels top → bottom
    final yTicks = [maxAmt, maxAmt * 2 / 3, maxAmt / 3, 0.0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Y-axis ──────────────────────────────────────────────────────────
        SizedBox(
          width: _yAxisWidth,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _xLabelHeight, right: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: yTicks
                  .map((v) => Text(
                        _formatY(v),
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 8,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.right,
                      ))
                  .toList(),
            ),
          ),
        ),

        // ── Chart canvas ─────────────────────────────────────────────────
        Expanded(
          child: _shouldScroll
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: trends.length * _pointWidth,
                    child: _ChartCanvas(
                      normalised: normalised,
                      xLabels: xLabels,
                      xLabelHeight: _xLabelHeight,
                    ),
                  ),
                )
              : _ChartCanvas(
                  normalised: normalised,
                  xLabels: xLabels,
                  xLabelHeight: _xLabelHeight,
                  expand: true,
                ),
        ),
      ],
    );
  }
}

// ── Canvas widget ──────────────────────────────────────────────────────────

class _ChartCanvas extends StatelessWidget {
  final List<double> normalised;
  final List<String> xLabels;
  final double xLabelHeight;
  final bool expand;

  const _ChartCanvas({
    required this.normalised,
    required this.xLabels,
    required this.xLabelHeight,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final painter = _ChartPainter(
      normalised: normalised,
      xLabels: xLabels,
      xLabelHeight: xLabelHeight,
    );
    return expand
        ? CustomPaint(painter: painter, child: const SizedBox.expand())
        : CustomPaint(painter: painter);
  }
}

// ── CustomPainter ──────────────────────────────────────────────────────────

class _ChartPainter extends CustomPainter {
  final List<double> normalised;
  final List<String> xLabels;
  final double xLabelHeight;

  const _ChartPainter({
    required this.normalised,
    required this.xLabels,
    required this.xLabelHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final count = normalised.length;
    if (count < 2) return;

    final chartH = size.height - xLabelHeight;

    // Grid lines
    final gridP = Paint()
      ..color = AppColors.grey.withValues(alpha: 0.12)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 3; i++) {
      final y = chartH * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridP);
    }

    // Compute points
    final pts = List.generate(count, (i) {
      final x = size.width * i / (count - 1);
      final y = chartH * (1.0 - normalised[i]);
      return Offset(x, y);
    });

    // Build smooth curve paths
    final linePath = Path()..moveTo(pts[0].dx, pts[0].dy);
    final fillPath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < count; i++) {
      final cpX = (pts[i - 1].dx + pts[i].dx) / 2;
      linePath.cubicTo(cpX, pts[i - 1].dy, cpX, pts[i].dy, pts[i].dx, pts[i].dy);
      fillPath.cubicTo(cpX, pts[i - 1].dy, cpX, pts[i].dy, pts[i].dx, pts[i].dy);
    }
    fillPath
      ..lineTo(pts.last.dx, chartH)
      ..lineTo(pts.first.dx, chartH)
      ..close();

    // Draw gradient fill
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.sceTeal.withValues(alpha: 0.28),
            AppColors.sceTeal.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartH))
        ..style = PaintingStyle.fill,
    );

    // Draw line
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.sceTeal
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots on data points
    final dotFill = Paint()
      ..color = AppColors.sceTeal
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = const Color(0xFF1A2235)
      ..style = PaintingStyle.fill;
    for (final p in pts) {
      canvas.drawCircle(p, 4.0, dotBorder);
      canvas.drawCircle(p, 2.5, dotFill);
    }

    // X-axis labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    // For very dense views, skip labels so they don't overlap
    final step = count > 20 ? 5 : (count > 10 ? 2 : 1);
    for (int i = 0; i < count; i++) {
      if (i % step != 0 && i != count - 1) continue;
      tp.text = TextSpan(
        text: xLabels[i],
        style: const TextStyle(color: AppColors.grey, fontSize: 8.5),
      );
      tp.layout();
      final x = (size.width * i / (count - 1) - tp.width / 2)
          .clamp(0.0, size.width - tp.width);
      tp.paint(canvas, Offset(x, chartH + 4));
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.normalised != normalised || old.xLabels != xLabels;
}
