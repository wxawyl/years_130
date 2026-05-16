import 'package:flutter/material.dart';
import '../theme/mood_colors.dart';

class MoodIndicator extends StatelessWidget {
  final MoodTheme theme;
  final double size;
  final bool showName;
  final bool showDescription;

  const MoodIndicator({
    super.key,
    required this.theme,
    this.size = 80,
    this.showName = true,
    this.showDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: theme.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              theme.emoji,
              style: TextStyle(fontSize: size * 0.5),
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 12),
          Text(
            theme.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: theme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        if (showDescription) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              theme.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: theme.textColor.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final MoodTheme? selectedTheme;
  final Function(MoodTheme) onThemeSelected;

  const ThemeSelector({
    super.key,
    this.selectedTheme,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '选择心情主题',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: MoodTheme.all.length,
            itemBuilder: (context, index) {
              final theme = MoodTheme.all[index];
              final isSelected = selectedTheme?.type == theme.type;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _ThemeOption(
                  theme: theme,
                  isSelected: isSelected,
                  onTap: () => onThemeSelected(theme),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final MoodTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? theme.primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              theme.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              theme.name,
              style: TextStyle(
                fontSize: 11,
                color: theme.textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
