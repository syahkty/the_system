import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../providers/system_provider.dart';

class StatusWindowScreen extends StatelessWidget {
  const StatusWindowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hunter = context.watch<SystemProvider>().hunter;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF050505), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. HEADER: NAMA, STREAK, & RANK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // KIRI: NAMA
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PLAYER NAME", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2)),
                        const SizedBox(height: 4),
                        Text(
                          hunter.name.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ],
                    ),

                    // KANAN: STREAK & RANK
                    Row(
                      children: [
                        // 🔥 DAILY STREAK BADGE (KEMBALI LAGI!)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.1),
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.2),
                                    blurRadius: 8
                                )
                              ]
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${hunter.dailyStreak}",
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🏆 RANK BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withOpacity(0.1),
                            border: Border.all(color: Colors.cyanAccent, width: 1),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 8)],
                          ),
                          child: Text(
                            hunter.rank,
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // --- 2. GOLD DISPLAY (DI TENGAH ATAS) ---
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Text(
                            "${hunter.gold} GOLD",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            )
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- 3. LEVEL & XP ---
                Center(
                  child: Column(
                    children: [
                      const Text("LEVEL", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2)),
                      Text(
                        "${hunter.level}",
                        style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [Shadow(color: Colors.blueAccent, blurRadius: 20)]
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: (hunter.currentXp / hunter.maxXp).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[900],
                  progressColor: const Color(0xFF00E5FF),
                  barRadius: const Radius.circular(6),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("${hunter.currentXp} / ${hunter.maxXp} XP", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ),

                const SizedBox(height: 40),

                // --- 4. RADAR CHART ---
                const Text("ATTRIBUTE CHART", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: RadarChart(
                    RadarChartData(
                      dataSets: [
                        RadarDataSet(
                          fillColor: const Color(0xFF00E5FF).withOpacity(0.15),
                          borderColor: const Color(0xFF00E5FF),
                          entryRadius: 3,
                          borderWidth: 2,
                          dataEntries: [
                            RadarEntry(value: hunter.strength.toDouble()),
                            RadarEntry(value: hunter.intelligence.toDouble()),
                            RadarEntry(value: hunter.artistry.toDouble()),
                            RadarEntry(value: hunter.vitality.toDouble()),
                            RadarEntry(value: hunter.charisma.toDouble()),
                          ],
                        ),
                      ],
                      radarBackgroundColor: Colors.transparent,
                      borderData: FlBorderData(show: false),
                      radarBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                      titlePositionPercentageOffset: 0.1,
                      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      tickCount: 1,
                      ticksTextStyle: const TextStyle(color: Colors.transparent),
                      gridBorderData: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                      getTitle: (index, angle) {
                        switch (index) {
                          case 0: return const RadarChartTitle(text: '🔴 STR', angle: 0);
                          case 1: return const RadarChartTitle(text: '🔵 INT', angle: 0);
                          case 2: return const RadarChartTitle(text: '🟣 ART', angle: 0);
                          case 3: return const RadarChartTitle(text: '🟢 VIT', angle: 0);
                          case 4: return const RadarChartTitle(text: '🟠 CHR', angle: 0);
                          default: return const RadarChartTitle(text: '');
                        }
                      },
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 1000),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),

                const SizedBox(height: 20),

                // --- 5. DETAIL STATS (LIST) ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow("Strength", hunter.strength, Colors.redAccent),
                      _buildStatRow("Intelligence", hunter.intelligence, Colors.blueAccent),
                      _buildStatRow("Artistry", hunter.artistry, Colors.purpleAccent),
                      _buildStatRow("Vitality", hunter.vitality, Colors.greenAccent),
                      _buildStatRow("Charisma", hunter.charisma, Colors.orangeAccent),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          Text("$value", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}