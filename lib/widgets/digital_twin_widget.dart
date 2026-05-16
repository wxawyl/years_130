import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/twin_visual_params.dart';
import '../providers/theme_provider.dart';
import 'twin_face_widget.dart';
import 'twin_body_widget.dart';
import 'twin_effects_widget.dart';

class DigitalTwinWidget extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const DigitalTwinWidget({
    super.key,
    this.size = 200,
    this.onTap,
  });

  @override
  State<DigitalTwinWidget> createState() => _DigitalTwinWidgetState();
}

class _DigitalTwinWidgetState extends State<DigitalTwinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = themeProvider.currentTheme;
        final params = TwinVisualParams.fromMoodTheme(theme);

        return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathingAnimation.value,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size * 1.2,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      TwinEffectsWidget(
                        effects: params.effects,
                        size: widget.size,
                        moodType: params.moodType,
                      ),
                      Positioned(
                        top: widget.size * 0.25,
                        child: TwinBodyWidget(
                          params: params.body,
                          size: widget.size,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: TwinFaceWidget(
                          params: params.face,
                          size: widget.size,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}