import 'package:flutter/material.dart';
import 'package:course/core/utils/l10n_extension.dart';

class DrawingBoardWidget extends StatefulWidget {
  final List<Path> outlinePaths;
  final double size;
  final Function(List<List<Offset>>) onStrokesUpdated;
  final Function(bool)? onDrawing;

  const DrawingBoardWidget({
    super.key,
    required this.outlinePaths,
    required this.size,
    required this.onStrokesUpdated,
    this.onDrawing,
  });

  @override
  State<DrawingBoardWidget> createState() => _DrawingBoardWidgetState();
}

class _DrawingBoardWidgetState extends State<DrawingBoardWidget> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _showHint = true;

  void _onPointerDown(PointerDownEvent event) {
    widget.onDrawing?.call(true);
    setState(() {
      _currentStroke = [event.localPosition];
      _strokes.add(_currentStroke);
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      _currentStroke.add(event.localPosition);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    widget.onDrawing?.call(false);
    widget.onStrokesUpdated(_strokes);
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
    widget.onStrokesUpdated(_strokes);
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      widget.onStrokesUpdated(_strokes);
    }
  }

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drawing Board
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Hint Layer (Được lưu thành bitmap tĩnh)
                if (_showHint)
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _HintPainter(
                          outlinePaths: widget.outlinePaths,
                          originalSize: 1024,
                          hintColor: colors.onSurfaceVariant.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),

                // Drawing Layer (Chỉ vẽ lại lớp này khi tay di chuyển)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      onPointerMove: _onPointerMove,
                      onPointerUp: _onPointerUp,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (_) {},
                        onHorizontalDragUpdate: (_) {},
                        child: CustomPaint(
                          painter: _DrawingPainter(
                            strokes: _strokes,
                            strokeColor: colors.primary,
                          ),
                          size: Size(widget.size, widget.size),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_showHint ? Icons.visibility_off : Icons.visibility),
              tooltip: context.l10n.drawingToggleHint,
              onPressed: _toggleHint,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: context.l10n.drawingUndo,
              onPressed: _strokes.isNotEmpty ? _undo : null,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: context.l10n.drawingClearAll,
              onPressed: _strokes.isNotEmpty ? _clear : null,
              color: colors.error,
            ),
          ],
        ),
      ],
    );
  }
}

class _HintPainter extends CustomPainter {
  final List<Path> outlinePaths;
  final double originalSize;
  final Color hintColor;

  _HintPainter({
    required this.outlinePaths,
    required this.originalSize,
    required this.hintColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ khung kẻ ô chữ điền tự cách
    final gridPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    // Vẽ đường ngang giữa
    _drawDashedLine(canvas, Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);
    // Vẽ đường dọc giữa
    _drawDashedLine(canvas, Offset(size.width / 2, 0), Offset(size.width / 2, size.height), gridPaint);

    final minDimension = size.width < size.height ? size.width : size.height;
    final scale = (minDimension / originalSize) * 0.85;
    
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, -scale);
    canvas.translate(-originalSize / 2, -originalSize / 2);

    final paint = Paint()
      ..color = hintColor
      ..style = PaintingStyle.fill;

    for (final path in outlinePaths) {
      canvas.drawPath(path, paint);
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HintPainter oldDelegate) {
    return oldDelegate.showHint != showHint || oldDelegate.outlinePaths != outlinePaths;
  }
  
  bool get showHint => true;

  // Hàm hỗ trợ vẽ nét đứt
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

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color strokeColor;

  _DrawingPainter({
    required this.strokes,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return true;
  }
}
