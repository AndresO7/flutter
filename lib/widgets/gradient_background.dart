import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool isLogin;
  final bool useBlueGradient;

  const GradientBackground({
    super.key, 
    required this.child,
    this.isLogin = true,
    this.useBlueGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: useBlueGradient 
                  ? [AppTheme.accentBlueColor, AppTheme.accentBlueColor.withOpacity(0.7), AppTheme.accentBlueColor.withOpacity(0.4)]
                  : (isLogin 
                      ? AppTheme.primaryGradient
                      : [Colors.white, Colors.white.withOpacity(0.9), Colors.white]),
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        if (isLogin)
          Positioned(
            top: -100,
            left: -100,
            right: -100,
            child: WavePainter(
              height: 400,
              useBlueGradient: useBlueGradient,
            ),
          ),
        if (isLogin)
          Positioned(
            top: 100,
            left: -150,
            right: -150,
            child: WavePainter(
              height: 300,
              transparency: 0.4,
              useBlueGradient: useBlueGradient,
            ),
          ),
        if (isLogin)
          Positioned(
            top: 50,
            left: -200,
            right: -200,
            child: WavePainter(
              height: 350,
              transparency: 0.2,
              reverse: true,
              useBlueGradient: useBlueGradient,
            ),
          ),
        SafeArea(child: child),
      ],
    );
  }
}

class WavePainter extends StatelessWidget {
  final double height;
  final double transparency;
  final bool reverse;
  final bool useBlueGradient;

  const WavePainter({
    super.key,
    required this.height,
    this.transparency = 0.6,
    this.reverse = false,
    this.useBlueGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: WaveCustomPainter(
          transparency: transparency,
          reverse: reverse,
          useBlueGradient: useBlueGradient,
        ),
        size: Size(MediaQuery.of(context).size.width, height),
      ),
    );
  }
}

class WaveCustomPainter extends CustomPainter {
  final double transparency;
  final bool reverse;
  final bool useBlueGradient;

  WaveCustomPainter({
    this.transparency = 0.6,
    this.reverse = false,
    this.useBlueGradient = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (useBlueGradient 
          ? AppTheme.accentBlueColor 
          : AppTheme.primaryColor).withOpacity(transparency)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, reverse ? 0 : size.height);

    double amplitude = size.height * 0.4;
    double waveWidth = size.width * 1.2;
    double frequency = 2.0;

    for (double x = 0; x <= size.width; x++) {
      double y = reverse
          ? amplitude * (1 + 0.5 * (1 + sin(2 * pi * frequency * x / waveWidth)))
          : size.height - amplitude * (1 + 0.5 * (1 + sin(2 * pi * frequency * x / waveWidth)));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, reverse ? size.height : 0);
    path.lineTo(0, reverse ? size.height : 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 