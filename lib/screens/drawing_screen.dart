import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final GlobalKey _paintKey = GlobalKey();

  final List<List<Offset>> _lines = [];
  List<Offset> _currentLine = [];

  void _startLine(Offset point) {
    _currentLine = [point];
  }

  void _addPoint(Offset point) {
    setState(() {
      _currentLine.add(point);
    });
  }

  void _endLine() {
    setState(() {
      _lines.add(_currentLine);
      _currentLine = [];
    });
  }

  Future<Uint8List> _exportPng() async {
    final boundary =
        _paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _saveAndClose() async {
    final pngBytes = await _exportPng();

    // 👉 Später: Upload zu Supabase
    // JETZT: nur zurückgeben
    Navigator.pop(context, pngBytes);
  }

  void _clear() {
    setState(() {
      _lines.clear();
      _currentLine.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zeichnung"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clear,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndClose,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (d) => _startLine(d.localPosition),
        onPanUpdate: (d) => _addPoint(d.localPosition),
        onPanEnd: (_) => _endLine(),
        child: RepaintBoundary(
          key: _paintKey,
          child: CustomPaint(
            painter: _DrawingPainter(_lines, _currentLine),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final List<Offset> currentLine;

  _DrawingPainter(this.lines, this.currentLine);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }

    for (int i = 0; i < currentLine.length - 1; i++) {
      canvas.drawLine(currentLine[i], currentLine[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
