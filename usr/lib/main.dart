import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Plot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const PlotScreen(),
    );
  }
}

class PlotScreen extends StatelessWidget {
  const PlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figure 14: Mathematical Plot'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: MathematicalPlotPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MathematicalPlotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = 30.0; // Adjust scale to zoom in/out

    // 1. Paint for axes
    final axisPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1.0;

    // Draw X-axis
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);
    // Draw Y-axis
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);

    // 2. Paint for the curve
    final curvePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 3. Create the path for the function
    final path = Path();

    // Function: y = e^(-damping * x) * cos(frequency * x)
    const damping = 0.4;
    const frequency = 5.0;

    // Start path from the left edge
    double startX = -center.dx / scale;
    double startY = exp(-damping * startX) * cos(frequency * startX);
    path.moveTo(0, center.dy - startY * scale);

    // 4. Loop through each pixel horizontally to draw the plot
    for (double i = 1; i < size.width; i++) {
      // Convert pixel x-coordinate to mathematical x-coordinate
      double x = (i - center.dx) / scale;

      // Calculate the corresponding mathematical y-coordinate
      double y = exp(-damping * x) * cos(frequency * x);

      // Convert mathematical y-coordinate back to pixel y-coordinate and draw a line
      path.lineTo(i, center.dy - y * scale);
    }

    // 5. Draw the path on the canvas
    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // The plot is static, so no need to repaint
  }
}
