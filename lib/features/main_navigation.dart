import 'package:flutter/material.dart';
import 'package:the_system/features/quest_board/screens/quest_list_screen.dart';
import 'package:the_system/features/shop/screens/shop_screen.dart';
import 'dashboard/screens/status_window_screen.dart';
import 'dashboard/screens/status_window_screen.dart';
import 'quest_board/screens/quest_list_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar Halaman yang tersedia
  final List<Widget> _screens = [
    const StatusWindowScreen(), // Index 0: Status Player
    const QuestListScreen(),    // Index 1: Papan Misi
    // Nanti kita tambah Index 2: Shop / Inventory
    const ShopScreen(),
    const Center(child: Text("SHOP (LOCKED)", style: TextStyle(color: Colors.grey))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah sesuai menu yang dipilih
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Navigasi Bawah a la Game RPG
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0D0D0D), // Hitam Pekat
          selectedItemColor: const Color(0xFF00E5FF), // Biru Neon (Aktif)
          unselectedItemColor: Colors.grey, // Abu-abu (Tidak Aktif)
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false, // Biar minimalis
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'STATUS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'QUESTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), // Ikon sementara
              label: 'SHOP',
            ),
          ],
        ),
      ),
    );
  }
}