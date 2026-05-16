import 'health_vector.dart';

class RagSearchResult {
  final HealthVector vector;
  final double similarity;
  final String? highlightedText;

  RagSearchResult({
    required this.vector,
    required this.similarity,
    this.highlightedText,
  });

  String get relevanceDisplay {
    if (similarity >= 0.9) {
      return '高度相关';
    } else if (similarity >= 0.7) {
      return '相关';
    } else if (similarity >= 0.5) {
      return '部分相关';
    } else {
      return '弱相关';
    }
  }
}
