import 'package:flutter/material.dart';
import '../models/twin_visual_params.dart';
import '../theme/mood_colors.dart';

class TwinEffectsWidget extends StatefulWidget {
  final List<TwinEffect> effects;
  final double size;
  final MoodType moodType;

  const TwinEffectsWidget({
    super.key,
    required this.effects,
    required this.size,
    required this.moodType,
  });

  @override
  State<TwinEffectsWidget> createState() => _TwinEffectsWidgetState();
}

class _TwinEffectsWidgetState extends State<TwinEffectsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
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
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.2,
      child: Stack(
        children: [
          if (widget.effects.any((e) => e.type == TwinEffectType.aura))
            _buildAuraEffect(),
          if (widget.effects.any((e) => e.type == TwinEffectType.glow))
            _buildGlowEffect(),
          if (widget.effects.any((e) => e.type == TwinEffectType.sparkle))
            _buildSparkleEffect(),
        ],
      ),
    );
  }

  Widget _buildAuraEffect() {
    final aura = widget.effects.firstWhere((e) => e.type == TwinEffectType.aura);
    final theme = MoodTheme.fromType(widget.moodType);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size * 1.2,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.2),
                radius: 0.8,
                colors: [
                  theme.gradientColors.last.withOpacity(0.4 * aura.intensity),
                  theme.gradientColors.last.withOpacity(0.1 * aura.intensity),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowEffect() {
    final glow = widget.effects.firstWhere((e) => e.type == TwinEffectType.glow);
    final theme = MoodTheme.fromType(widget.moodType);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.1),
              radius: 0.5,
              colors: [
                theme.gradientColors.first.withOpacity(0.3 * glow.intensity),
                Colors.transparent,
              ],
              stops: const [0.3, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSparkleEffect() {
    final sparkle = widget.effects.firstWhere((e) => e.type == TwinEffectType.sparkle);
    final theme = MoodTheme.fromType(widget.moodType);

    return Stack(
      children: List.generate(6, (index) {
        final radius = widget.size * 0.35;
        final x = widget.size / 2 + radius * 0.4;
        final y = widget.size * 0.3 + radius * 0.4 * (index % 2 == 0 ? 1 : -1);

        return Positioned(
          left: x,
          top: y,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final progress = (_animationController.value + index * 0.1) % 1.0;
              final scale = 0.5 + progress * 0.5;
              final opacity = (1 - progress) * sparkle.intensity;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.gradientColors.first.withOpacity(opacity),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.gradientColors.first.withOpacity(opacity * 0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}