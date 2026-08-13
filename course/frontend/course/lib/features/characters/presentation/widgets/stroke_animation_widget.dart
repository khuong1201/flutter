import 'dart:convert';
import 'dart:ui';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:course/core/utils/l10n_extension.dart';
import 'character_stroke_painter.dart';

class StrokeAnimationWidget extends StatefulWidget {
  final List<StrokeDataEntity> strokeData;
  final double size;
  final Color strokeColor;
  final Color outlineColor;

  const StrokeAnimationWidget({
    super.key,
    required this.strokeData,
    this.size = 200,
    this.strokeColor = Colors.black,
    this.outlineColor = Colors.grey,
  });

  @override
  State<StrokeAnimationWidget> createState() => _StrokeAnimationWidgetState();
}

class _StrokeAnimationWidgetState extends State<StrokeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Path> _outlinePaths = [];
  List<Path> _medianPaths = [];
  List<List<PathMetric>> _medianMetrics = [];
  List<double> _strokeLengths = [];
  double _totalLength = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _parsePaths();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000 + widget.strokeData.length * 400), // Vẽ chậm lại
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });

    // Bắt đầu animation ngay khi render xong (sau 500ms delay cho mượt)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.forward();
        setState(() => _isPlaying = true);
      }
    });
  }

  void _parsePaths() {
    _outlinePaths = [];
    _medianPaths = [];
    _medianMetrics = [];
    _strokeLengths = [];
    _totalLength = 0;

    // Sắp xếp nét vẽ theo thứ tự
    final sortedData = List<StrokeDataEntity>.from(widget.strokeData)
      ..sort((a, b) => a.order.compareTo(b.order));

    for (var stroke in sortedData) {
      // 1. Parse Outline Path từ SVG String
      final outlinePath = parseSvgPathData(stroke.outlinePath);
      _outlinePaths.add(outlinePath);

      // 2. Parse Median Path từ mảng toạ độ dạng JSON string
      final medianPath = _parseMedianPath(stroke.medianPath);
      _medianPaths.add(medianPath);

      // Tính toán chiều dài của nét vẽ (dùng PathMetric)
      final metrics = medianPath.computeMetrics().toList();
      _medianMetrics.add(metrics);
      
      double length = 0;
      for (var metric in metrics) {
        length += metric.length;
      }
      _strokeLengths.add(length);
      _totalLength += length;
    }
  }

  Path _parseMedianPath(String? jsonStr) {
    final path = Path();
    if (jsonStr == null) return path;
    try {
      final List<dynamic> points = jsonDecode(jsonStr);
      if (points.isNotEmpty) {
        path.moveTo((points[0][0] as num).toDouble(), (points[0][1] as num).toDouble());
        for (int i = 1; i < points.length; i++) {
          path.lineTo((points[i][0] as num).toDouble(), (points[i][1] as num).toDouble());
        }
      }
    } catch (e) {
      debugPrint('Lỗi parse medianPath: $e');
    }
    return path;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.reset(); // Mất hết nét vẽ (để rỗng)
      setState(() => _isPlaying = false);
    } else {
      _controller.reset(); // Bắt đầu lại từ đầu
      _controller.forward();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            // Khung và Nét vẽ
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: CharacterStrokePainter(
                    animation: _controller,
                    outlinePaths: _outlinePaths,
                    medianPaths: _medianPaths,
                    medianMetrics: _medianMetrics,
                    strokeLengths: _strokeLengths,
                    totalLength: _totalLength,
                    strokeColor: widget.strokeColor,
                    outlineColor: widget.outlineColor,
                    originalSize: 1024,
                  ),
                ),
              ),
            ),
            
            // Nút Play/Pause ở góc trái trên
            Positioned(
              left: 8,
              top: 8,
              child: FloatingActionButton.small(
                heroTag: null, // Tránh lỗi trùng heroTag
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                foregroundColor: Theme.of(context).colorScheme.primary,
                onPressed: _togglePlayPause,
                tooltip: _isPlaying ? context.l10n.animationPauseTooltip : context.l10n.animationPlayTooltip,
                child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
