import 'package:caloriecounter/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class NutritientChart extends StatelessWidget {
  final double achieved;
  final double goal;
  final String achievedPostfix;
  final String additionalText;
  final Color color;
  final double size;

  NutritientChart({
    required this.achieved, 
    required this.goal,
    required this.color, 
    required this.size, 
    required this.achievedPostfix, 
    required this.additionalText
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: NutritientChartPainter(achieved, goal, color, achievedPostfix, additionalText),
    );
  }
}

class NutritientChartPainter extends CustomPainter {
  final double achieved;
  final String achievedPostfix;
  final String additionalText;
  final double goal;
  final Color color;

  NutritientChartPainter(this.achieved, this.goal, this.color, this.achievedPostfix, this.additionalText);

  @override
  void paint(Canvas canvas, Size size) {
    final double percentage = achieved / goal;
    final double sweepAngle = percentage * 360;
    final double innerRadius = size.width / 3;
    final double textPadding = 5;
    final double additionalPadding = 15;

    final paintAchieved = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final paintRemaining = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      _degreesToRadians(30),
      _degreesToRadians(sweepAngle),
      true,
      paintAchieved,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      _degreesToRadians(30 + sweepAngle),
      _degreesToRadians(360 - sweepAngle),
      true,
      paintRemaining,
    );

    final paintInnerCircle = Paint()
      ..color = AppColors.saveButtonColor;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: innerRadius),
      0,
      2 * pi,
      true,
      paintInnerCircle,
    );

    final headerPainter = TextPainter(
      text: TextSpan(
        text: '${achieved.toInt()}${achievedPostfix}',
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    headerPainter.layout();
    headerPainter.paint(canvas, Offset((size.width - headerPainter.width) / 2, (size.height - headerPainter.height - textPadding) / 2));

    final additionalPainter = TextPainter(
      text: TextSpan(
        text: '${additionalText}', 
        style: TextStyle(color: const Color.fromARGB(255, 78, 74, 74), fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    additionalPainter.layout();
    additionalPainter.paint(canvas, Offset((size.width - additionalPainter.width) / 2, 
      (size.height - headerPainter.height - textPadding) / 2 + additionalPadding));
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  @override
  bool shouldRepaint(NutritientChartPainter oldDelegate) {
    return oldDelegate.achieved != achieved || oldDelegate.goal != goal;
  }
}