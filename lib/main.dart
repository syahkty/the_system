import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Import model yang sudah kita buat
import 'features/main_navigation.dart';
import 'models/hunter_model.dart';
import 'models/quest_model.dart';

import 'features/dashboard/screens/status_window_screen.dart'; // Import Screen baru
import 'providers/system_provider.dart'; // Import Provider baru

import 'providers/quest_provider.dart';
import 'features/quest_board/screens/quest_list_screen.dart';
// Import logic provider (nanti kita buat setelah ini)
// import 'providers/quest_provider.dart';

// Import halaman dashboard (nanti kita buat setelah ini)
// import 'features/dashboard/screens/status_window_screen.dart';

void main() async {
  // 1. Wajib ada jika main() menggunakan async
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HunterModelAdapter());
  Hive.registerAdapter(QuestModelAdapter());
  Hive.registerAdapter(InventoryItemAdapter());
  await Hive.openBox<HunterModel>('hunterBox');
  await Hive.openBox<QuestModel>('questBox');

  runApp(
    // BUNGKUS DENGAN MULTIPROVIDER
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SystemProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
      ],
      child: const TheSystemApp(),
    ),
  );
}

class TheSystemApp extends StatelessWidget {
  const TheSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The System',
      // Tema Gelap a la Solo Leveling
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Hitam pekat
        primaryColor: const Color(0xFF00E5FF), // Biru Neon
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      // Sementara kita tampilkan layar kosong dulu agar tidak error
      home: const MainNavigation(),
    );
  }
}