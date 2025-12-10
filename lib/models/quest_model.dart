import 'package:hive/hive.dart';

part 'quest_model.g.dart'; // Akan merah sebentar, abaikan.

@HiveType(typeId: 1) // TypeID 0 sudah dipakai Hunter, jadi ini 1
class QuestModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int xpReward;

  @HiveField(4)
  String difficulty; // 'Easy', 'Medium', 'Hard', 'Boss'

  @HiveField(5)
  bool isCompleted;

  @HiveField(6) // Field Baru
  String category; // Isinya nanti: 'STR', 'INT', 'ART', 'VIT', atau 'CHR'

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.difficulty,
    this.isCompleted = false,
    this.category = 'INT', // Default
  });

  // --- MAGIC FUNCTION ---
  // Fungsi ini mengubah data JSON dari AI menjadi Object QuestModel
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString() + (json['title'] ?? ''),
      title: json['title'] ?? 'Unknown Quest',
      description: json['description'] ?? 'No instructions provided.',
      xpReward: json['xp'] ?? 50,
      difficulty: json['difficulty'] ?? 'Easy',
      category: json['category'] ?? 'VIT',
      isCompleted: false,
    );
  }
}