class FoodRecognitionResult {
  final String name;
  final double calorie;
  final double probability;
  final bool hasCalorie;

  FoodRecognitionResult({
    required this.name,
    required this.calorie,
    required this.probability,
    required this.hasCalorie,
  });

  factory FoodRecognitionResult.fromJson(Map<String, dynamic> json) {
    return FoodRecognitionResult(
      name: json['name'] ?? '',
      calorie: double.tryParse(json['calorie']?.toString() ?? '0') ?? 0,
      probability: double.tryParse(json['probability']?.toString() ?? '0') ?? 0,
      hasCalorie: json['has_calorie'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calorie': calorie,
      'probability': probability,
      'has_calorie': hasCalorie,
    };
  }

  double get caloriesPerServing => calorie;

  double get confidencePercentage => (probability * 100).clamp(0, 100);

  bool get isHighConfidence => probability >= 0.7;
}

class FoodRecognitionResponse {
  final int resultNum;
  final List<FoodRecognitionResult> results;
  final int? errorCode;
  final String? errorMsg;

  FoodRecognitionResponse({
    required this.resultNum,
    required this.results,
    this.errorCode,
    this.errorMsg,
  });

  factory FoodRecognitionResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['result'] as List<dynamic>?)
            ?.map((e) => FoodRecognitionResult.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return FoodRecognitionResponse(
      resultNum: json['result_num'] ?? 0,
      results: results,
      errorCode: json['error_code'],
      errorMsg: json['error_msg'],
    );
  }

  bool get isSuccess => errorCode == null || errorCode == 0;

  bool get hasResults => results.isNotEmpty;
}
