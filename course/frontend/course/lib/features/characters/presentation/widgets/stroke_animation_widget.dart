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
  final bool loop;
  final bool showGrid;
  final bool showControls;
  final bool animate;
  final double animationSpeedMultiplier;
  final VoidCallback? onAnimationCompleted;

  const StrokeAnimationWidget({
    super.key,
    required this.strokeData,
    this.size = 200,
    this.strokeColor = Colors.black,
    this.outlineColor = Colors.grey,
    this.loop = false,
    this.showGrid = true,
    this.showControls = true,
    this.animate = true,
    this.animationSpeedMultiplier = 1.0,
    this.onAnimationCompleted,
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
      duration: Duration(milliseconds: ((800 + widget.strokeData.length * 150) * widget.animationSpeedMultiplier).toInt()), 
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationCompleted?.call();
        if (widget.loop && mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _controller.forward(from: 0);
            }
          });
        } else if (mounted) {
          setState(() => _isPlaying = false);
        }
      } else if (status == AnimationStatus.dismissed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });

    // Bắt đầu animation ngay khi render xong (sau 500ms delay cho mượt)
    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.forward();
          setState(() => _isPlaying = true);
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant StrokeAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.strokeData != oldWidget.strokeData) {
      _parsePaths();
      _controller.duration = Duration(milliseconds: ((800 + widget.strokeData.length * 150) * widget.animationSpeedMultiplier).toInt());
      if (_isPlaying) {
        _controller.forward(from: 0);
      }
    }
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
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.showGrid ? colors.surfaceContainerHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: widget.showGrid ? Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)) : null,
          boxShadow: widget.showGrid ? [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Stack(
          children: [
            // Nền chữ mờ và Grid (Được bọc RepaintBoundary để cache thành Bitmap)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: GridAndOutlinePainter(
                      outlinePaths: _outlinePaths,
                      outlineColor: widget.outlineColor,
                      originalSize: 1024,
                      showGrid: widget.showGrid,
                    ),
                  ),
                ),
              ),
            ),
            // Nét vẽ động (Chỉ vẽ lại lớp này mỗi khung hình)
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
                    originalSize: 1024,
                  ),
                ),
              ),
            ),
            if (widget.showControls)
              Positioned(
                left: 8,
                top: 8,
                child: FloatingActionButton.small(
                  heroTag: null,
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
