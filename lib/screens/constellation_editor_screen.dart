import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConstellationEditorScreen extends StatefulWidget {
  const ConstellationEditorScreen({super.key});

  @override
  State<ConstellationEditorScreen> createState() => _ConstellationEditorScreenState();
}

class _ConstellationEditorScreenState extends State<ConstellationEditorScreen> {
  int _currentStep = 1;
  ui.Image? _backgroundImage;
  List<Offset> _points = [];
  List<List<int>> _connections = [];
  int? _connectionStartIndex;
  Offset? _dragPosition; // Track current drag position
  bool _isDragging = false; // Track if currently dragging

  void _handleCanvasTap(TapDownDetails details, BoxConstraints constraints) {
    if (_currentStep != 1) {
      return;
    }

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    // Convert to normalized coordinates (0-1)
    final normalizedX = localPosition.dx / constraints.maxWidth;
    final normalizedY = localPosition.dy / (constraints.maxWidth * 9 / 16);

    print('Normalized coordinates: $normalizedX, $normalizedY');

    setState(() {
      _points.add(Offset(normalizedX, normalizedY));
    });
  }

  void _handleDragStart(DragStartDetails details, BoxConstraints constraints) {
    if (_currentStep != 2) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    // Convert to normalized coordinates
    final normalizedX = localPosition.dx / constraints.maxWidth;
    final normalizedY = localPosition.dy / (constraints.maxWidth * 9 / 16);

    // Find the closest point within threshold
    int? closestPoint;
    double minDistance = double.infinity;

    for (int i = 0; i < _points.length; i++) {
      final distance = (_points[i] - Offset(normalizedX, normalizedY)).distance;
      if (distance < 0.05 && distance < minDistance) {
        // 5% of screen width as threshold
        minDistance = distance;
        closestPoint = i;
      }
    }

    if (closestPoint != null) {
      setState(() {
        _connectionStartIndex = closestPoint;
        _isDragging = true;
        _dragPosition = localPosition;
      });
    }
    setState(() {
      _points.add(Offset(normalizedX, normalizedY));
    });
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (!_isDragging || _connectionStartIndex == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    setState(() {
      _dragPosition = localPosition;
    });
  }

  void _handleDragEnd(DragEndDetails details, BoxConstraints constraints) {
    if (!_isDragging || _connectionStartIndex == null || _dragPosition == null) {
      setState(() {
        _isDragging = false;
        _connectionStartIndex = null;
        _dragPosition = null;
      });
      return;
    }

    // Convert current drag position to normalized coordinates
    final normalizedX = _dragPosition!.dx / constraints.maxWidth;
    final normalizedY = _dragPosition!.dy / (constraints.maxWidth * 9 / 16);

    // Find the closest point to the end position
    int? closestPoint;
    double minDistance = double.infinity;

    for (int i = 0; i < _points.length; i++) {
      if (i == _connectionStartIndex) continue; // Skip the start point

      final distance = (_points[i] - Offset(normalizedX, normalizedY)).distance;
      if (distance < 0.05 && distance < minDistance) {
        // 5% of screen width as threshold
        minDistance = distance;
        closestPoint = i;
      }
    }

    if (closestPoint != null) {
      // Check if connection already exists
      final connectionExists = _connections.any((conn) =>
          (conn[0] == _connectionStartIndex && conn[1] == closestPoint) ||
          (conn[1] == _connectionStartIndex && conn[0] == closestPoint));

      if (!connectionExists) {
        setState(() {
          _connections.add([_connectionStartIndex!, closestPoint!]);
        });
      }
    }

    setState(() {
      _isDragging = false;
      _connectionStartIndex = null;
      _dragPosition = null;
    });
  }

  String _generateCode() {
    final buffer = StringBuffer();
    buffer.writeln('ConstellationLevel(');
    buffer.writeln('  name: "Custom Constellation",');
    buffer.writeln('  requiredScore: 1000,');
    buffer.writeln('  starPositions: const [');

    for (final point in _points) {
      // Offset the Y position by 0.5 to center the constellation
      buffer.writeln(
        '    Offset(${point.dx.toStringAsFixed(2)}, ${(point.dy / 2 - 0.5).toStringAsFixed(2)}),',
      );
    }

    buffer.writeln('  ],');
    buffer.writeln('  connections: const [');

    for (final connection in _connections) {
      buffer.writeln('    [${connection[0]}, ${connection[1]}],');
    }

    buffer.writeln('  ],');
    buffer.writeln('  isClosedLoop: false,');
    buffer.writeln(');');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    _buildStepIndicator(
                      1,
                      'Place Points',
                      Icons.add_location,
                    ),
                    _buildStepDivider(),
                    _buildStepIndicator(
                      2,
                      'Create Connections',
                      Icons.timeline,
                    ),
                    _buildStepDivider(),
                    _buildStepIndicator(
                      3,
                      'Generate Code',
                      Icons.code,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_currentStep == 1 || _currentStep == 2) ...[
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.network(
                  'https://www.star-registration.com/cdn/shop/articles/31_Jungfrau_1200x1200.jpg?v=1681373719',
                ),
              ),
            ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => _handleCanvasTap(
                      details,
                      constraints,
                    ),
                    onPanStart: (details) => _handleDragStart(details, constraints),
                    onPanUpdate: (details) => _handleDragUpdate(details, constraints),
                    onPanEnd: (details) => _handleDragEnd(details, constraints),
                    child: CustomPaint(
                      painter: ConstellationPainter(
                        points: _points,
                        connections: _connections,
                        connectionStartIndex: _connectionStartIndex,
                        isDragging: _isDragging,
                        dragPosition: _dragPosition,
                        constraints: constraints,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (_currentStep == 3) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      _generateCode(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copied to clipboard'),
                          ),
                        );

                        Clipboard.setData(
                          ClipboardData(text: _generateCode()),
                        );
                      },
                      child: const Text('Copy to Clipboard'),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Navigation buttons
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Row(
                  children: [
                    if (_currentStep > 1)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: const Text('Back'),
                      ),
                    const SizedBox(width: 16),
                    if (_currentStep < 3)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep++;
                          });
                        },
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          border: isActive ? Border.all(color: Colors.blue) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isCompleted
                  ? Colors.green
                  : isActive
                      ? Colors.blue
                      : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDivider() {
    return const SizedBox(
      width: 16,
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}

class ConstellationPainter extends CustomPainter {
  final List<Offset> points;
  final List<List<int>> connections;
  final int? connectionStartIndex;
  final bool isDragging;
  final Offset? dragPosition;
  final BoxConstraints constraints;

  ConstellationPainter({
    required this.points,
    required this.connections,
    this.connectionStartIndex,
    required this.isDragging,
    this.dragPosition,
    required this.constraints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connections
    for (final connection in connections) {
      final start = Offset(
        points[connection[0]].dx * size.width,
        points[connection[0]].dy * size.width * 9 / 16,
      );
      final end = Offset(
        points[connection[1]].dx * size.width,
        points[connection[1]].dy * size.width * 9 / 16,
      );
      canvas.drawLine(start, end, paint);
    }

    // Draw dragging line
    if (isDragging && connectionStartIndex != null && dragPosition != null) {
      final start = Offset(
        points[connectionStartIndex!].dx * size.width,
        points[connectionStartIndex!].dy * size.height,
      );

      final dragPaint = Paint()
        ..color = Colors.blue.withOpacity(0.6)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(start, dragPosition!, dragPaint);

      // Draw snap radius indicators for nearby points
      for (int i = 0; i < points.length; i++) {
        if (i == connectionStartIndex) continue;

        final point = Offset(
          points[i].dx * size.width,
          points[i].dy * size.width * 9 / 16,
        );

        if ((point - dragPosition!).distance < 30) {
          canvas.drawCircle(
            point,
            15,
            Paint()
              ..color = Colors.blue.withOpacity(0.3)
              ..style = PaintingStyle.fill,
          );
        }
      }
    }

    // Draw points
    for (int i = 0; i < points.length; i++) {
      final point = Offset(
        points[i].dx * size.width,
        points[i].dy * size.width * 9 / 16,
      );

      // Draw point highlight/glow
      if (i == connectionStartIndex || (isDragging && dragPosition != null && (point - dragPosition!).distance < 30)) {
        canvas.drawCircle(
          point,
          10,
          Paint()
            ..color = Colors.blue.withOpacity(0.3)
            ..style = PaintingStyle.fill,
        );
      }

      // Draw the point
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
