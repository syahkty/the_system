import 'package:flutter/material.dart';

class LevelUpDialog extends StatefulWidget {
  final int newLevel;
  const LevelUpDialog({super.key, required this.newLevel});

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Animasi "Pop" saat muncul
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D).withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyanAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              const Text(
                "SYSTEM ALERT",
                style: TextStyle(color: Colors.grey, letterSpacing: 3, fontSize: 10),
              ),
              const SizedBox(height: 10),

              // Judul Besar
              const Text(
                "LEVEL UP!",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  shadows: [Shadow(color: Colors.blue, blurRadius: 10)],
                ),
              ),
              const Divider(color: Colors.cyanAccent, thickness: 0.5),
              const SizedBox(height: 10),

              // Level Baru
              Text(
                "${widget.newLevel}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 64,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 20),

              // Info Stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Text("All Stats have increased!", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 4),
                    Text("HP & MP Restored.", style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Tutup
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("CONFIRM"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}