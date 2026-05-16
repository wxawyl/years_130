import 'package:flutter/material.dart';
import '../models/twin_visual_params.dart';

class TwinBodyWidget extends StatelessWidget {
  final TwinBodyState params;
  final double size;

  const TwinBodyWidget({
    super.key,
    required this.params,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: TwinBodyPainter(params: params),
      ),
    );
  }
}

class TwinBodyPainter extends CustomPainter {
  final TwinBodyState params;

  TwinBodyPainter({required this.params});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3);
    final bodyWidth = size.width * 0.5;
    final bodyHeight = size.height * 0.5;

    _drawNeck(canvas, center, bodyWidth);
    _drawTorso(canvas, center, bodyWidth, bodyHeight);
    _drawArms(canvas, center, bodyWidth, bodyHeight);
    if (params.muscleDefinition > 0.5) {
      _drawMuscleDetails(canvas, center, bodyWidth, bodyHeight);
    }
  }

  void _drawNeck(Canvas canvas, Offset center, double bodyWidth) {
    final neckPaint = Paint()
      ..color = const Color(0xFFFFE4C4)
      ..style = PaintingStyle.fill;

    final neckWidth = bodyWidth * 0.3;
    final neckHeight = bodyWidth * 0.15;

    final neckRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bodyWidth * 0.1),
      width: neckWidth,
      height: neckHeight,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(neckRect, Radius.circular(neckWidth * 0.3)),
      neckPaint,
    );
  }

  void _drawTorso(Canvas canvas, Offset center, double bodyWidth, double bodyHeight) {
    final postureAdjustment = (params.posture - 0.5) * 10;

    final bodyColor = _getBodyColor();
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final shoulderWidth = bodyWidth * 0.8;
    final waistWidth = bodyWidth * 0.6;

    final path = Path();
    
    path.moveTo(
      center.dx - shoulderWidth / 2,
      center.dy + bodyWidth * 0.2 - postureAdjustment,
    );
    
    path.quadraticBezierTo(
      center.dx - shoulderWidth / 2 - 5,
      center.dy + bodyHeight * 0.3,
      center.dx - waistWidth / 2,
      center.dy + bodyHeight * 0.5,
    );
    
    path.lineTo(
      center.dx - waistWidth / 2,
      center.dy + bodyHeight * 0.9,
    );
    
    path.lineTo(
      center.dx + waistWidth / 2,
      center.dy + bodyHeight * 0.9,
    );
    
    path.lineTo(
      center.dx + waistWidth / 2,
      center.dy + bodyHeight * 0.5,
    );
    
    path.quadraticBezierTo(
      center.dx + shoulderWidth / 2 + 5,
      center.dy + bodyHeight * 0.3,
      center.dx + shoulderWidth / 2,
      center.dy + bodyWidth * 0.2 - postureAdjustment,
    );
    
    path.close();

    canvas.drawPath(path, bodyPaint);

    final bodyBorder = Paint()
      ..color = bodyColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, bodyBorder);
  }

  Color _getBodyColor() {
    if (params.muscleDefinition > 0.7) {
      return const Color(0xFF5D9CEC);
    } else if (params.muscleDefinition > 0.4) {
      return const Color(0xFF6BB3E9);
    } else if (params.muscleDefinition > 0.2) {
      return const Color(0xFFAED6F1);
    }
    return const Color(0xFFD4E6F1);
  }

  void _drawArms(Canvas canvas, Offset center, double bodyWidth, double bodyHeight) {
    final armColor = _getBodyColor();
    final armPaint = Paint()
      ..color = armColor
      ..style = PaintingStyle.fill;

    final shoulderWidth = bodyWidth * 0.8;
    final armWidth = bodyWidth * 0.15;

    final leftArmPath = Path();
    leftArmPath.moveTo(
      center.dx - shoulderWidth / 2 - 5,
      center.dy + bodyWidth * 0.2,
    );
    leftArmPath.quadraticBezierTo(
      center.dx - shoulderWidth / 2 - armWidth * 1.2,
      center.dy + bodyHeight * 0.35,
      center.dx - shoulderWidth / 2 - armWidth,
      center.dy + bodyHeight * 0.6,
    );
    leftArmPath.quadraticBezierTo(
      center.dx - shoulderWidth / 2,
      center.dy + bodyHeight * 0.5,
      center.dx - shoulderWidth / 2,
      center.dy + bodyHeight * 0.3,
    );
    leftArmPath.close();
    canvas.drawPath(leftArmPath, armPaint);

    final rightArmPath = Path();
    rightArmPath.moveTo(
      center.dx + shoulderWidth / 2 + 5,
      center.dy + bodyWidth * 0.2,
    );
    rightArmPath.quadraticBezierTo(
      center.dx + shoulderWidth / 2 + armWidth * 1.2,
      center.dy + bodyHeight * 0.35,
      center.dx + shoulderWidth / 2 + armWidth,
      center.dy + bodyHeight * 0.6,
    );
    rightArmPath.quadraticBezierTo(
      center.dx + shoulderWidth / 2,
      center.dy + bodyHeight * 0.5,
      center.dx + shoulderWidth / 2,
      center.dy + bodyHeight * 0.3,
    );
    rightArmPath.close();
    canvas.drawPath(rightArmPath, armPaint);
  }

  void _drawMuscleDetails(Canvas canvas, Offset center, double bodyWidth, double bodyHeight) {
    final alpha = (0.2 + params.muscleDefinition * 0.3).toDouble();
    final muscleColor = Color.fromARGB((alpha * 255).toInt(), 46, 134, 171);
    final musclePaint = Paint()
      ..color = muscleColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final chestLeft = Rect.fromCenter(
      center: Offset(center.dx - bodyWidth * 0.12, center.dy + bodyHeight * 0.3),
      width: bodyWidth * 0.15,
      height: bodyWidth * 0.12,
    );
    canvas.drawOval(chestLeft, musclePaint);

    final chestRight = Rect.fromCenter(
      center: Offset(center.dx + bodyWidth * 0.12, center.dy + bodyHeight * 0.3),
      width: bodyWidth * 0.15,
      height: bodyWidth * 0.12,
    );
    canvas.drawOval(chestRight, musclePaint);

    final abs = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bodyHeight * 0.55),
      width: bodyWidth * 0.2,
      height: bodyWidth * 0.2,
    );
    canvas.drawOval(abs, musclePaint);
  }

  @override
  bool shouldRepaint(covariant TwinBodyPainter oldDelegate) {
    return oldDelegate.params != params;
  }
}