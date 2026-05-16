import 'package:flutter/material.dart';
import '../theme/mood_colors.dart';

class TwinFaceState {
  final double eyeBrightness;
  final double skinHealth;
  final double darkCircles;
  final double puffyEyes;
  final double glow;

  const TwinFaceState({
    this.eyeBrightness = 0.7,
    this.skinHealth = 0.7,
    this.darkCircles = 0.0,
    this.puffyEyes = 0.0,
    this.glow = 0.5,
  });

  factory TwinFaceState.fromMoodType(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return const TwinFaceState(
          eyeBrightness: 0.95,
          skinHealth: 0.95,
          darkCircles: 0.0,
          puffyEyes: 0.0,
          glow: 0.9,
        );
      case MoodType.good:
        return const TwinFaceState(
          eyeBrightness: 0.8,
          skinHealth: 0.85,
          darkCircles: 0.0,
          puffyEyes: 0.0,
          glow: 0.7,
        );
      case MoodType.moderate:
        return const TwinFaceState(
          eyeBrightness: 0.6,
          skinHealth: 0.65,
          darkCircles: 0.1,
          puffyEyes: 0.0,
          glow: 0.4,
        );
      case MoodType.needsAttention:
        return const TwinFaceState(
          eyeBrightness: 0.35,
          skinHealth: 0.4,
          darkCircles: 0.6,
          puffyEyes: 0.5,
          glow: 0.2,
        );
      case MoodType.tired:
        return const TwinFaceState(
          eyeBrightness: 0.2,
          skinHealth: 0.3,
          darkCircles: 0.8,
          puffyEyes: 0.7,
          glow: 0.1,
        );
    }
  }

  TwinFaceState copyWith({
    double? eyeBrightness,
    double? skinHealth,
    double? darkCircles,
    double? puffyEyes,
    double? glow,
  }) {
    return TwinFaceState(
      eyeBrightness: eyeBrightness ?? this.eyeBrightness,
      skinHealth: skinHealth ?? this.skinHealth,
      darkCircles: darkCircles ?? this.darkCircles,
      puffyEyes: puffyEyes ?? this.puffyEyes,
      glow: glow ?? this.glow,
    );
  }

  TwinFaceState lerp(TwinFaceState other, double t) {
    return TwinFaceState(
      eyeBrightness: eyeBrightness + (other.eyeBrightness - eyeBrightness) * t,
      skinHealth: skinHealth + (other.skinHealth - skinHealth) * t,
      darkCircles: darkCircles + (other.darkCircles - darkCircles) * t,
      puffyEyes: puffyEyes + (other.puffyEyes - puffyEyes) * t,
      glow: glow + (other.glow - glow) * t,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eyeBrightness': eyeBrightness,
      'skinHealth': skinHealth,
      'darkCircles': darkCircles,
      'puffyEyes': puffyEyes,
      'glow': glow,
    };
  }

  factory TwinFaceState.fromMap(Map<String, dynamic> map) {
    return TwinFaceState(
      eyeBrightness: map['eyeBrightness'] ?? 0.7,
      skinHealth: map['skinHealth'] ?? 0.7,
      darkCircles: map['darkCircles'] ?? 0.0,
      puffyEyes: map['puffyEyes'] ?? 0.0,
      glow: map['glow'] ?? 0.5,
    );
  }
}

class TwinBodyState {
  final double muscleDefinition;
  final double posture;
  final double energyLevel;
  final bool isSweating;

  const TwinBodyState({
    this.muscleDefinition = 0.3,
    this.posture = 0.5,
    this.energyLevel = 0.5,
    this.isSweating = false,
  });

  factory TwinBodyState.fromMoodType(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return const TwinBodyState(
          muscleDefinition: 0.85,
          posture: 0.95,
          energyLevel: 0.95,
          isSweating: false,
        );
      case MoodType.good:
        return const TwinBodyState(
          muscleDefinition: 0.6,
          posture: 0.8,
          energyLevel: 0.75,
          isSweating: false,
        );
      case MoodType.moderate:
        return const TwinBodyState(
          muscleDefinition: 0.4,
          posture: 0.6,
          energyLevel: 0.55,
          isSweating: false,
        );
      case MoodType.needsAttention:
        return const TwinBodyState(
          muscleDefinition: 0.25,
          posture: 0.35,
          energyLevel: 0.3,
          isSweating: false,
        );
      case MoodType.tired:
        return const TwinBodyState(
          muscleDefinition: 0.15,
          posture: 0.2,
          energyLevel: 0.15,
          isSweating: false,
        );
    }
  }

  TwinBodyState copyWith({
    double? muscleDefinition,
    double? posture,
    double? energyLevel,
    bool? isSweating,
  }) {
    return TwinBodyState(
      muscleDefinition: muscleDefinition ?? this.muscleDefinition,
      posture: posture ?? this.posture,
      energyLevel: energyLevel ?? this.energyLevel,
      isSweating: isSweating ?? this.isSweating,
    );
  }

  TwinBodyState lerp(TwinBodyState other, double t) {
    return TwinBodyState(
      muscleDefinition: muscleDefinition + (other.muscleDefinition - muscleDefinition) * t,
      posture: posture + (other.posture - posture) * t,
      energyLevel: energyLevel + (other.energyLevel - energyLevel) * t,
      isSweating: t < 0.5 ? isSweating : other.isSweating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muscleDefinition': muscleDefinition,
      'posture': posture,
      'energyLevel': energyLevel,
      'isSweating': isSweating,
    };
  }

  factory TwinBodyState.fromMap(Map<String, dynamic> map) {
    return TwinBodyState(
      muscleDefinition: map['muscleDefinition'] ?? 0.3,
      posture: map['posture'] ?? 0.5,
      energyLevel: map['energyLevel'] ?? 0.5,
      isSweating: map['isSweating'] ?? false,
    );
  }
}

class TwinSkinState {
  final double glow;
  final double healthiness;

  const TwinSkinState({
    this.glow = 0.5,
    this.healthiness = 0.7,
  });

  factory TwinSkinState.fromMoodType(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return const TwinSkinState(
          glow: 0.9,
          healthiness: 0.95,
        );
      case MoodType.good:
        return const TwinSkinState(
          glow: 0.7,
          healthiness: 0.85,
        );
      case MoodType.moderate:
        return const TwinSkinState(
          glow: 0.4,
          healthiness: 0.65,
        );
      case MoodType.needsAttention:
        return const TwinSkinState(
          glow: 0.2,
          healthiness: 0.4,
        );
      case MoodType.tired:
        return const TwinSkinState(
          glow: 0.1,
          healthiness: 0.3,
        );
    }
  }

  TwinSkinState copyWith({
    double? glow,
    double? healthiness,
  }) {
    return TwinSkinState(
      glow: glow ?? this.glow,
      healthiness: healthiness ?? this.healthiness,
    );
  }

  TwinSkinState lerp(TwinSkinState other, double t) {
    return TwinSkinState(
      glow: glow + (other.glow - glow) * t,
      healthiness: healthiness + (other.healthiness - healthiness) * t,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'glow': glow,
      'healthiness': healthiness,
    };
  }

  factory TwinSkinState.fromMap(Map<String, dynamic> map) {
    return TwinSkinState(
      glow: map['glow'] ?? 0.5,
      healthiness: map['healthiness'] ?? 0.7,
    );
  }
}

enum TwinEffectType {
  glow,
  sparkle,
  sweat,
  aura,
  heartbeat,
}

class TwinEffect {
  final TwinEffectType type;
  final double intensity;
  final Duration duration;

  const TwinEffect({
    required this.type,
    required this.intensity,
    required this.duration,
  });

  static List<TwinEffect> fromMoodType(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return const [
          TwinEffect(
            type: TwinEffectType.aura,
            intensity: 0.7,
            duration: Duration(seconds: 2),
          ),
          TwinEffect(
            type: TwinEffectType.sparkle,
            intensity: 0.5,
            duration: Duration(milliseconds: 800),
          ),
        ];
      case MoodType.good:
        return const [
          TwinEffect(
            type: TwinEffectType.glow,
            intensity: 0.4,
            duration: Duration(seconds: 2),
          ),
        ];
      case MoodType.moderate:
        return [];
      case MoodType.needsAttention:
        return [];
      case MoodType.tired:
        return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'intensity': intensity,
      'duration': duration.inMilliseconds,
    };
  }

  factory TwinEffect.fromMap(Map<String, dynamic> map) {
    return TwinEffect(
      type: TwinEffectType.values[map['type'] ?? 0],
      intensity: map['intensity'] ?? 0.5,
      duration: Duration(milliseconds: map['duration'] ?? 2000),
    );
  }
}

class TwinVisualParams {
  final TwinFaceState face;
  final TwinBodyState body;
  final TwinSkinState skin;
  final MoodType moodType;
  final List<TwinEffect> effects;

  const TwinVisualParams({
    required this.face,
    required this.body,
    required this.skin,
    required this.moodType,
    required this.effects,
  });

  factory TwinVisualParams.initial() {
    return TwinVisualParams(
      face: const TwinFaceState(),
      body: const TwinBodyState(),
      skin: const TwinSkinState(),
      moodType: MoodType.good,
      effects: [],
    );
  }

  factory TwinVisualParams.fromMoodTheme(MoodTheme theme) {
    return TwinVisualParams(
      face: TwinFaceState.fromMoodType(theme.type),
      body: TwinBodyState.fromMoodType(theme.type),
      skin: TwinSkinState.fromMoodType(theme.type),
      moodType: theme.type,
      effects: TwinEffect.fromMoodType(theme.type),
    );
  }

  TwinVisualParams copyWith({
    TwinFaceState? face,
    TwinBodyState? body,
    TwinSkinState? skin,
    MoodType? moodType,
    List<TwinEffect>? effects,
  }) {
    return TwinVisualParams(
      face: face ?? this.face,
      body: body ?? this.body,
      skin: skin ?? this.skin,
      moodType: moodType ?? this.moodType,
      effects: effects ?? this.effects,
    );
  }

  TwinVisualParams lerp(TwinVisualParams other, double t) {
    return TwinVisualParams(
      face: face.lerp(other.face, t),
      body: body.lerp(other.body, t),
      skin: skin.lerp(other.skin, t),
      moodType: t < 0.5 ? moodType : other.moodType,
      effects: t < 0.5 ? effects : other.effects,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'face': face.toMap(),
      'body': body.toMap(),
      'skin': skin.toMap(),
      'moodType': moodType.index,
      'effects': effects.map((e) => e.toMap()).toList(),
    };
  }

  factory TwinVisualParams.fromMap(Map<String, dynamic> map) {
    return TwinVisualParams(
      face: TwinFaceState.fromMap(map['face'] ?? {}),
      body: TwinBodyState.fromMap(map['body'] ?? {}),
      skin: TwinSkinState.fromMap(map['skin'] ?? {}),
      moodType: MoodType.values[map['moodType'] ?? 1],
      effects: (map['effects'] as List<dynamic>?)
          ?.map((e) => TwinEffect.fromMap(e))
          .toList() ?? [],
    );
  }
}