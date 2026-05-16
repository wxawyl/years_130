import 'package:flutter/material.dart';
import '../models/twin_visual_params.dart';

class TwinFaceWidget extends StatelessWidget {
  final TwinFaceState params;
  final double size;

  const TwinFaceWidget({
    super.key,
    required this.params,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.6,
      child: CustomPaint(
        painter: TwinFacePainter(params: params),
      ),
    );
  }
}

class TwinFacePainter extends CustomPainter {
  final TwinFaceState params;

  TwinFacePainter({required this.params});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceWidth = size.width * 0.7;
    final faceHeight = size.height * 0.9;

    _drawFace(canvas, center, faceWidth, faceHeight);
    _drawEyes(canvas, center, faceWidth);
    _drawMouth(canvas, center, faceWidth);
    _drawCheeks(canvas, center, faceWidth);
    if (params.darkCircles > 0.3) {
      _drawDarkCircles(canvas, center, faceWidth);
    }
  }

  void _drawFace(Canvas canvas, Offset center, double faceWidth, double faceHeight) {
    final facePaint = Paint()
      ..color = _getSkinColor()
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = _getGlowColor()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 * params.glow)
      ..style = PaintingStyle.fill;

    final faceRect = Rect.fromCenter(
      center: center,
      width: faceWidth,
      height: faceHeight,
    );

    if (params.glow > 0.3) {
      canvas.drawOval(
        faceRect.inflate(10 * params.glow),
        glowPaint,
      );
    }

    canvas.drawOval(faceRect, facePaint);

    final faceBorder = Paint()
      ..color = _getSkinColor().withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(faceRect, faceBorder);
  }

  Color _getSkinColor() {
    final baseColor = const Color(0xFFFFE4C4);
    final healthAdjustment = (params.skinHealth - 0.5) * 0.2;
    
    final r = ((baseColor.red / 255 + healthAdjustment * 0.1) * 255).toInt().clamp(0, 255);
    final g = ((baseColor.green / 255 + healthAdjustment * 0.08) * 255).toInt().clamp(0, 255);
    final b = ((baseColor.blue / 255 + healthAdjustment * 0.05) * 255).toInt().clamp(0, 255);
    
    return Color.fromARGB(255, r, g, b);
  }

  Color _getGlowColor() {
    final healthColor = params.skinHealth > 0.7
        ? const Color(0xFFFFD700)
        : const Color(0xFFB0C4DE);
    return healthColor.withValues(alpha: 0.3 * params.glow);
  }

  void _drawEyes(Canvas canvas, Offset center, double faceWidth) {
    final eyeSpacing = faceWidth * 0.35;
    final eyeY = center.dy - faceWidth * 0.05;
    
    _drawEye(
      canvas,
      Offset(center.dx - eyeSpacing, eyeY),
      faceWidth * 0.12,
    );
    _drawEye(
      canvas,
      Offset(center.dx + eyeSpacing, eyeY),
      faceWidth * 0.12,
    );
  }

  void _drawEye(Canvas canvas, Offset eyeCenter, double eyeSize) {
    final eyeWhite = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    final irisColor = Color.lerp(
      const Color(0xFF4A90E2),
      const Color(0xFF1E3A5F),
      1 - params.eyeBrightness,
    )!;
    
    final iris = Paint()
      ..color = irisColor
      ..style = PaintingStyle.fill;

    final pupil = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeHeight = eyeSize * 0.7 * (0.5 + params.eyeBrightness * 0.5);
    final eyeOval = Rect.fromCenter(
      center: eyeCenter,
      width: eyeSize,
      height: eyeHeight,
    );

    canvas.drawOval(eyeOval, eyeWhite);

    final irisSize = eyeSize * 0.5;
    final irisRect = Rect.fromCenter(
      center: eyeCenter,
      width: irisSize,
      height: irisSize * 0.7,
    );
    canvas.drawOval(irisRect, iris);

    final pupilSize = irisSize * 0.4;
    final pupilRect = Rect.fromCenter(
      center: eyeCenter,
      width: pupilSize,
      height: pupilSize * 0.7,
    );
    canvas.drawOval(pupilRect, pupil);

    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: params.eyeBrightness * 0.8)
      ..style = PaintingStyle.fill;
    
    final highlightRect = Rect.fromCenter(
      center: Offset(eyeCenter.dx - irisSize * 0.15, eyeCenter.dy - irisSize * 0.15),
      width: irisSize * 0.2,
      height: irisSize * 0.2,
    );
    canvas.drawOval(highlightRect, highlight);
  }

  void _drawMouth(Canvas canvas, Offset center, double faceWidth) {
    final mouthY = center.dy + faceWidth * 0.2;
    final mouthWidth = faceWidth * 0.3;
    
    final moodCurve = _getMoodCurve();
    
    final mouthPaint = Paint()
      ..color = const Color(0xFFE57373)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    final startX = center.dx - mouthWidth / 2;
    final endX = center.dx + mouthWidth / 2;
    final controlY = mouthY + moodCurve * mouthWidth * 0.2;
    
    path.moveTo(startX, mouthY);
    path.quadraticBezierTo(center.dx, controlY, endX, mouthY);
    
    canvas.drawPath(path, mouthPaint);

    if (moodCurve < -0.3) {
      final lipPaint = Paint()
        ..color = const Color(0xFFE57373).withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      
      final lipPath = Path();
      lipPath.moveTo(startX, mouthY);
      lipPath.quadraticBezierTo(center.dx, controlY, endX, mouthY);
      lipPath.quadraticBezierTo(center.dx, mouthY + mouthWidth * 0.1, startX, mouthY);
      canvas.drawPath(lipPath, lipPaint);
    }
  }

  double _getMoodCurve() {
    if (params.skinHealth > 0.8) return -0.5;
    if (params.skinHealth > 0.6) return -0.2;
    if (params.skinHealth > 0.4) return 0.0;
    return 0.3;
  }

  void _drawCheeks(Canvas canvas, Offset center, double faceWidth) {
    final cheekY = center.dy + faceWidth * 0.05;
    final cheekSpacing = faceWidth * 0.4;
    final cheekSize = faceWidth * 0.15;
    
    final cheekColor = _getCheekColor();
    final cheekPaint = Paint()
      ..color = cheekColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final leftCheek = Rect.fromCenter(
      center: Offset(center.dx - cheekSpacing, cheekY),
      width: cheekSize,
      height: cheekSize * 0.6,
    );
    canvas.drawOval(leftCheek, cheekPaint);

    final rightCheek = Rect.fromCenter(
      center: Offset(center.dx + cheekSpacing, cheekY),
      width: cheekSize,
      height: cheekSize * 0.6,
    );
    canvas.drawOval(rightCheek, cheekPaint);
  }

  Color _getCheekColor() {
    if (params.skinHealth > 0.7) {
      return const Color(0xFFFF9999).withValues(alpha: 0.5);
    } else if (params.skinHealth < 0.4) {
      return const Color(0xFFB0B0B0).withValues(alpha: 0.3);
    }
    return const Color(0xFFFFB6C1).withValues(alpha: 0.3);
  }

  void _drawDarkCircles(Canvas canvas, Offset center, double faceWidth) {
    final eyeSpacing = faceWidth * 0.35;
    final eyeY = center.dy - faceWidth * 0.05;
    final circleSize = faceWidth * 0.15;
    
    final darkCirclePaint = Paint()
      ..color = const Color(0xFF5C4033).withValues(alpha: 0.3 * params.darkCircles)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final leftCircle = Rect.fromCenter(
      center: Offset(center.dx - eyeSpacing, eyeY + circleSize * 0.3),
      width: circleSize,
      height: circleSize * 0.5,
    );
    canvas.drawOval(leftCircle, darkCirclePaint);

    final rightCircle = Rect.fromCenter(
      center: Offset(center.dx + eyeSpacing, eyeY + circleSize * 0.3),
      width: circleSize,
      height: circleSize * 0.5,
    );
    canvas.drawOval(rightCircle, darkCirclePaint);
  }

  @override
  bool shouldRepaint(covariant TwinFacePainter oldDelegate) {
    return oldDelegate.params != params;
  }
}