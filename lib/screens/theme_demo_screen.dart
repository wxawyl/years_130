import 'package:flutter/material.dart';
import '../theme/mood_colors.dart';
import '../widgets/mood_indicator.dart';
import '../widgets/dynamic_background.dart';

class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({super.key});

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  MoodTheme _selectedTheme = MoodTheme.good;
  double _sliderValue = 75;
  bool _hasSleptWell = true;
  bool _hasExercised = false;
  bool _isSleepDeprived = false;

  void _updateThemeFromSlider() {
    setState(() {
      _selectedTheme = MoodTheme.fromScore(
        _sliderValue,
        hasSleptWell: _hasSleptWell,
        hasExercised: _hasExercised,
        isSleepDeprived: _isSleepDeprived,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBackground(
      theme: _selectedTheme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('心情主题演示'),
          backgroundColor: _selectedTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: MoodIndicator(
                    theme: _selectedTheme,
                    size: 120,
                    showName: true,
                    showDescription: true,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '健康评分: ${_sliderValue.toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: _sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _sliderValue.toInt().toString(),
                        activeColor: _selectedTheme.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                          _updateThemeFromSlider();
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('0'),
                          Text('50'),
                          Text('100'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '健康状态选项',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('昨晚睡得很好'),
                        value: _hasSleptWell,
                        onChanged: (value) {
                          setState(() {
                            _hasSleptWell = value;
                            if (value) _isSleepDeprived = false;
                          });
                          _updateThemeFromSlider();
                        },
                        activeColor: _selectedTheme.primaryColor,
                      ),
                      SwitchListTile(
                        title: const Text('今天运动了'),
                        value: _hasExercised,
                        onChanged: (value) {
                          setState(() {
                            _hasExercised = value;
                          });
                          _updateThemeFromSlider();
                        },
                        activeColor: _selectedTheme.primaryColor,
                      ),
                      SwitchListTile(
                        title: const Text('睡眠不足'),
                        value: _isSleepDeprived,
                        onChanged: (value) {
                          setState(() {
                            _isSleepDeprived = value;
                            if (value) _hasSleptWell = false;
                          });
                          _updateThemeFromSlider();
                        },
                        activeColor: _selectedTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                '所有主题预览',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: MoodTheme.all.map((theme) {
                  return _ThemePreviewCard(
                    theme: theme,
                    isSelected: _selectedTheme.type == theme.type,
                    onTap: () {
                      setState(() {
                        _selectedTheme = theme;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final MoodTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              theme.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              theme.name,
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
