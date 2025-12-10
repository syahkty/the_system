import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/quest_model.dart';
import '../../../../providers/quest_provider.dart';
import '../../../../providers/system_provider.dart';
import '../../dashboard/widgets/level_up_dialog.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;

  const QuestCard({super.key, required this.quest});

  // Helper Ikon Stats
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category) {
      case 'STR': return {'icon': Icons.fitness_center, 'color': Colors.redAccent, 'label': 'STR'};
      case 'INT': return {'icon': Icons.psychology, 'color': Colors.blueAccent, 'label': 'INT'};
      case 'ART': return {'icon': Icons.palette, 'color': Colors.purpleAccent, 'label': 'ART'};
      case 'VIT': return {'icon': Icons.favorite, 'color': Colors.greenAccent, 'label': 'VIT'};
      case 'CHR': return {'icon': Icons.record_voice_over, 'color': Colors.orangeAccent, 'label': 'CHR'};
      default: return {'icon': Icons.help_outline, 'color': Colors.grey, 'label': '???'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final int goldReward = (quest.xpReward / 2).floor();
    final statStyle = _getCategoryStyle(quest.category);

    Color difficultyColor;
    switch (quest.difficulty.toLowerCase()) {
      case 'easy': difficultyColor = Colors.greenAccent; break;
      case 'medium': difficultyColor = Colors.blueAccent; break;
      case 'hard': difficultyColor = Colors.orangeAccent; break;
      case 'boss': difficultyColor = Colors.redAccent; break;
      default: difficultyColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(
            color: quest.isCompleted ? Colors.grey.withOpacity(0.3) : difficultyColor.withOpacity(0.5),
            width: 1
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER: JUDUL & KESULITAN ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quest.title,
                  style: TextStyle(
                    color: quest.isCompleted ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  border: Border.all(color: difficultyColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quest.difficulty.toUpperCase(),
                  style: TextStyle(color: difficultyColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            quest.description,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.grey, thickness: 0.2),
          const SizedBox(height: 12),

          // --- FOOTER: HADIAH & TOMBOL (LAYOUT BARU ANTI-OVERFLOW) ---

          // 1. Baris Hadiah (Bisa di-scroll horizontal jika layar sempit)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBadge(Icons.bolt, "+${quest.xpReward} XP", Colors.blueAccent),
                const SizedBox(width: 8),
                _buildBadge(statStyle['icon'], "+${statStyle['label']}", statStyle['color']),
                const SizedBox(width: 8),
                _buildBadge(Icons.monetization_on, "+$goldReward G", Colors.amber),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Tombol Aksi (Full Width)
          SizedBox(
            width: double.infinity, // Agar tombol memenuhi lebar kartu
            child: quest.isCompleted
                ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("COMPLETED", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final systemProvider = context.read<SystemProvider>();
                final questProvider = context.read<QuestProvider>();

                // 1. Catat level LAMA sebelum xp ditambah
                final int oldLevel = systemProvider.hunter.level;

                // 2. Selesaikan Misi (Tambah XP, Gold, Stats, dan Bunyi Suara)
                questProvider.completeQuest(quest, systemProvider);

                // 3. Cek apakah level BARU lebih tinggi?
                if (systemProvider.hunter.level > oldLevel) {
                  // Jika ya, Tampilkan Popup Keren!
                  showDialog(
                    context: context,
                    barrierDismissible: false, // User wajib klik tombol Confirm
                    builder: (context) => LevelUpDialog(newLevel: systemProvider.hunter.level),
                  );
                }
              },
              child: const Text("COMPLETE MISSION", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget kecil untuk Badge agar kodingan rapi
  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}