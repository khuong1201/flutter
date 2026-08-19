import 'dart:ui';
import 'package:flutter/material.dart';

class GridAndOutlinePainter extends CustomPainter {
  final List<Path> outlinePaths;
  final Color outlineColor;
  final double originalSize;
  final bool showGrid;

  GridAndOutlinePainter({
    required this.outlinePaths,
    required this.outlineColor,
    required this.originalSize,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final gridPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
        
      _drawDashedLine(canvas, Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);
      _drawDashedLine(canvas, Offset(size.width / 2, 0), Offset(size.width / 2, size.height), gridPaint);
    }

    final minDimension = size.width < size.height ? size.width : size.height;
    final scale = (minDimension / originalSize) * 0.85;
    
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, -scale);
    canvas.translate(-originalSize / 2, -originalSize / 2);

    final outlinePaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    for (final path in outlinePaths) {
      canvas.drawPath(path, outlinePaint);
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GridAndOutlinePainter oldDelegate) {
    return oldDelegate.outlinePaths != outlinePaths || 
           oldDelegate.showGrid != showGrid;
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const int dashWidth = 4;
    const int dashSpace = 4;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    
    double startX = p1.dx;
    double startY = p1.dy;
    
    while (distance >= 0) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + dx * dashWidth, startY + dy * dashWidth),
        paint,
      );
      startX += dx * (dashWidth + dashSpace);
      startY += dy * (dashWidth + dashSpace);
      distance -= (dashWidth + dashSpace);
    }
  }
}

class CharacterStrokePainter extends CustomPainter {
  final Animation<double> animation;
  final List<Path> outlinePaths;
  final List<Path> medianPaths;
  final List<List<PathMetric>> medianMetrics;
  final List<double> strokeLengths;
  final double totalLength;
  final Color strokeColor;
  final double originalSize;

  CharacterStrokePainter({
    required this.animation,
    required this.outlinePaths,
    required this.medianPaths,
    required this.medianMetrics,
    required this.strokeLengths,
    required this.totalLength,
    required this.strokeColor,
    required this.originalSize,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final minDimension = size.width < size.height ? size.width : size.height;
    final scale = (minDimension / originalSize) * 0.85;
    
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, -scale);
    canvas.translate(-originalSize / 2, -originalSize / 2);

    if (totalLength == 0) {
      final fillPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.fill;
      for (final path in outlinePaths) {
        canvas.drawPath(path, fillPaint);
      }
      canvas.restore();
      return;
    }

    final currentTotalLength = animation.value * totalLength;
    double accumulatedLength = 0;

    final brushPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 140 // Điều chỉnh nét đủ dày để che clip
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < outlinePaths.length; i++) {
      final strokeLength = strokeLengths[i];
      final outline = outlinePaths[i];
      final median = medianPaths[i];

      if (accumulatedLength + strokeLength <= currentTotalLength) {
        // Nét này đã vẽ xong hoàn toàn
        canvas.save();
        canvas.clipPath(outline); // Giới hạn vùng tô là cái outline của chữ
        canvas.drawPath(median, brushPaint);
        canvas.restore();
      } else if (accumulatedLength < currentTotalLength) {
        // Nét này đang vẽ dở
        final currentStrokeLength = currentTotalLength - accumulatedLength;
        
        // Trích xuất path từ đoạn 0 đến currentStrokeLength
        final metrics = medianMetrics[i];
        final currentPath = Path();
        double currentExtracted = 0;
        
        for (var metric in metrics) {
          if (currentExtracted >= currentStrokeLength) break;
          final extractLength = (currentStrokeLength - currentExtracted).clamp(0.0, metric.length);
          currentPath.addPath(metric.extractPath(0, extractLength), Offset.zero);
          currentExtracted += extractLength;
        }

        canvas.save();
        canvas.clipPath(outline);
        canvas.drawPath(currentPath, brushPaint);
        canvas.restore();
      }
      accumulatedLength += strokeLength;
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CharacterStrokePainter oldDelegate) {
    return false; // repaint được trigger qua super(repaint: animation)
  }
}
