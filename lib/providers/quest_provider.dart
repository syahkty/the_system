import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/services/audio_service.dart';
import '../models/quest_model.dart';
import '../core/services/ai_service.dart';
import 'system_provider.dart'; // Kita butuh ini untuk kasih XP ke user

class QuestProvider extends ChangeNotifier {
  late Box<QuestModel> _questBox;
  final AiService _aiService = AiService();
  final AudioService _audio = AudioService();

  bool isLoading = false; // Untuk loading saat AI berpikir

  List<QuestModel> get quests => _questBox.values.toList();

  QuestProvider() {
    _init();
  }

  void _init() {
    _questBox = Hive.box<QuestModel>('questBox');
    notifyListeners();
  }

  // --- FUNGSI 1: GENERATE MISI PAKAI AI ---
  // Tambahkan parameter 'context' di sini
  Future<void> generateQuestsForGoal(BuildContext context, String userGoal) async {
    isLoading = true;
    notifyListeners();

    try {
      final newQuests = await _aiService.generateQuests(userGoal);

      for (var quest in newQuests) {
        _questBox.add(quest);
      }

      // Beritahu user berhasil
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New Directive Received."), backgroundColor: Colors.cyanAccent),
        );
      }

    } catch (e) {
      print("System Error: $e");

      // Tampilkan pesan error ke layar HP
      if (context.mounted) {
        String message = "System Error.";
        // Cek jika errornya karena Overloaded (503)
        if (e.toString().contains("503") || e.toString().contains("Overloaded")) {
          message = "System Overloaded (Traffic High). Try again in 1 minute.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- FUNGSI 2: SELESAIKAN MISI (CLAIM REWARD) ---
  void completeQuest(QuestModel quest, SystemProvider systemProvider) {
    if (quest.isCompleted) return;

    // 1. Tandai selesai di database
    quest.isCompleted = true;
    quest.save();

    // 2. Kirim XP ke SystemProvider (Naik Level!)
    systemProvider.addXp(quest.xpReward);
    systemProvider.addGold((quest.xpReward / 2).floor());
    systemProvider.addStat(quest.category, quest.xpReward);

    _audio.playQuestComplete();

    notifyListeners();
  }

  // Hapus misi jika tidak suka
  void deleteQuest(QuestModel quest) {
    quest.delete();
    notifyListeners();
  }
}