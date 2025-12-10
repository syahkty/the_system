import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/quest_provider.dart';
import '../widgets/quest_card.dart';

class QuestListScreen extends StatelessWidget {
  const QuestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QUEST BOARD", style: TextStyle(color: Colors.cyanAccent, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Consumer<QuestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }

          if (provider.quests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_late, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("NO ACTIVE QUESTS", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text("Tap + to generate missions from AI", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.quests.length,
            itemBuilder: (context, index) {
              // Balik urutan agar misi baru ada di atas
              final quest = provider.quests[provider.quests.length - 1 - index];
              return QuestCard(quest: quest);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          _showAddQuestDialog(context);
        },
      ),
    );
  }

  // Dialog untuk input tujuan ke AI
  void _showAddQuestDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("NEW DIRECTIVE", style: TextStyle(color: Colors.cyanAccent)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "What is your goal? (e.g. Master Flutter)",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          // Di dalam _showAddQuestDialog
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // Tutup dialog dulu
                Navigator.pop(context);

                // Panggil fungsi dengan context
                context.read<QuestProvider>().generateQuestsForGoal(context, controller.text);
              }
            },
            child: const Text("GENERATE", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}