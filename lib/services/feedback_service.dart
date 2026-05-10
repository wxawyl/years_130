import 'package:sqflite/sqflite.dart';
import '../models/feedback.dart';
import '../services/database_service.dart';

class FeedbackService {
  final DatabaseService _dbService = DatabaseService();

  Future<void> submitFeedback(Feedback feedback) async {
    final db = await _dbService.database;
    await db.insert(
      'feedbacks',
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Feedback>> getFeedbacks() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('feedbacks');
    return List.generate(maps.length, (i) => Feedback.fromMap(maps[i]));
  }

  Future<void> deleteFeedback(int id) async {
    final db = await _dbService.database;
    await db.delete(
      'feedbacks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}