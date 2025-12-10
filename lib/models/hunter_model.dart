import 'package:hive/hive.dart';

part 'hunter_model.g.dart';

// --- 1. CLASS: ITEM INVENTORY (TAS) ---
@HiveType(typeId: 2) // ID 2 khusus untuk Item
class InventoryItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String icon; // Emoji atau path gambar

  @HiveField(2)
  int quantity;

  InventoryItem({
    required this.name,
    required this.icon,
    this.quantity = 1
  });
}

// --- 2. CLASS: HUNTER (PLAYER) ---
@HiveType(typeId: 0) // ID 0 khusus untuk Player
class HunterModel extends HiveObject {
  // --- IDENTITY ---
  @HiveField(0)
  String name;

  @HiveField(1)
  int level;

  @HiveField(2)
  int currentXp;

  @HiveField(3)
  int maxXp;

  @HiveField(4)
  String rank;

  // --- STATS (5 ATTRIBUTES) ---
  @HiveField(5)
  int strength;

  @HiveField(6)
  int intelligence;

  @HiveField(8)
  int artistry;

  @HiveField(9)
  int vitality;

  @HiveField(10)
  int charisma;

  // --- CURRENCY ---
  @HiveField(7)
  int gold;

  // --- INVENTORY (TAS) ---
  // defaultValue: [] PENTING agar user lama tidak error (null check operator error)
  @HiveField(11, defaultValue: [])
  List<InventoryItem> inventory;

  // --- DAILY LOGIN (API HARIAN) ---
  @HiveField(12, defaultValue: 0)
  int dailyStreak;

  @HiveField(13)
  DateTime? lastLoginDate;

  HunterModel({
    this.name = 'Player',
    this.level = 1,
    this.currentXp = 0,
    this.maxXp = 100,
    this.rank = 'E-Rank',
    this.strength = 0,
    this.intelligence = 0,
    this.artistry = 0,
    this.vitality = 0,
    this.charisma = 0,
    this.gold = 0,
    this.dailyStreak = 0,
    this.lastLoginDate,
    List<InventoryItem>? inventory,
  }) : inventory = inventory ?? []; // Pastikan inventory tidak pernah null

  // Helper untuk Progress Bar di UI
  double get xpPercentage {
    if (maxXp == 0) return 0.0;
    return currentXp / maxXp;
  }
}