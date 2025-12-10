import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/services/audio_service.dart';
import '../models/hunter_model.dart';

class SystemProvider extends ChangeNotifier {
  final AudioService _audio = AudioService();
  late Box<HunterModel> _hunterBox;
  late HunterModel _hunter;

  HunterModel get hunter => _hunter;

  SystemProvider() {
    _init();
  }

  void _init() {
    _hunterBox = Hive.box<HunterModel>('hunterBox');

    // Cek apakah sudah ada data hunter? Jika tidak, buat baru.
    if (_hunterBox.isEmpty) {
      _hunter = HunterModel(name: 'Player One', lastLoginDate: DateTime.now());
      _hunterBox.add(_hunter);
    } else {
      _hunter = _hunterBox.getAt(0)!;
    }
    _checkDailyStreak();
    notifyListeners();
  }
  void _checkDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Jam 00:00:00 hari ini

    // Jika belum pernah login (user baru), set hari ini
    if (_hunter.lastLoginDate == null) {
      _hunter.lastLoginDate = today;
      _hunter.dailyStreak = 1;
      _hunter.save();
      return;
    }

    final lastLogin = _hunter.lastLoginDate!;
    final lastDate = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);

    final difference = today.difference(lastDate).inDays;

    if (difference == 0) {
      // Login di hari yang sama -> Tidak ada perubahan
      return;
    } else if (difference == 1) {
      // Login berturut-turut (Kemarin login, sekarang login) -> Streak Nambah!
      _hunter.dailyStreak++;
      _hunter.lastLoginDate = today;

      // Bonus XP kecil karena rajin login
      addXp(10);
      // Bonus suara
      _audio.playKaChing();
    } else {
      // Bolos lebih dari 1 hari -> Streak Reset :(
      _hunter.dailyStreak = 1; // Mulai lagi dari 1
      _hunter.lastLoginDate = today;
    }
    _hunter.save();
  }


  // Fungsi menambah XP (Dipanggil saat Quest selesai)
  void addXp(int amount) {
    _hunter.currentXp += amount;

    // Cek Level Up
    if (_hunter.currentXp >= _hunter.maxXp) {
      _levelUp();
    }

    _hunter.save(); // Simpan perubahan ke Database permanen
    notifyListeners(); // Kabari UI untuk update tampilan
  }

  void _levelUp() {
    _hunter.currentXp -= _hunter.maxXp;
    _hunter.level++;
    _hunter.maxXp = (_hunter.maxXp * 1.5).round();

    // --- BUNYIKAN SUARA! ---
    _audio.playLevelUp();
    // -----------------------

    // ... stats increase ...
  }

  // Tambah Gold (Panggil ini saat Quest Selesai)
  void addGold(int amount) {
    _hunter.gold += amount;
    _hunter.save();
    notifyListeners();
  }

  // Pakai Gold (Panggil ini saat Belanja)
  // Mengembalikan true jika berhasil, false jika uang tidak cukup
  bool spendGold(int amount) {
    if (_hunter.gold >= amount) {
      _hunter.gold -= amount;
      _hunter.save();
      notifyListeners();
      return true;
    } else {
      return false; // Uang gak cukup bos!
    }
  }

  void addStat(String category, int amount) {
    // Karena XP terlalu besar (misal 100), kita kecilkan untuk stats (misal jadi 1 atau 2 poin)
    int statPoint = (amount / 50).ceil(); // 100 XP = 2 Stat Point
    if (statPoint < 1) statPoint = 1;

    switch (category.toUpperCase()) {
      case 'STR': _hunter.strength += statPoint; break;
      case 'INT': _hunter.intelligence += statPoint; break;
      case 'ART': _hunter.artistry += statPoint; break;
      case 'VIT': _hunter.vitality += statPoint; break;
      case 'CHR': _hunter.charisma += statPoint; break;
      default: _hunter.intelligence += statPoint; // Default ke INT kalau error
    }
    _hunter.save();
    notifyListeners();
  }

  bool buyItem(String name, String icon, int price) {
    if (_hunter.gold >= price) {
      // 1. Bayar
      _hunter.gold -= price;

      // 2. Cek apakah item sudah ada di tas?
      final existingIndex = _hunter.inventory.indexWhere((item) => item.name == name);

      if (existingIndex != -1) {
        // Kalau ada, tambah jumlahnya
        _hunter.inventory[existingIndex].quantity++;
      } else {
        // Kalau belum, buat item baru
        _hunter.inventory.add(InventoryItem(name: name, icon: icon, quantity: 1));
      }

      _audio.playKaChing();

      _hunter.save();
      notifyListeners();
      return true;
    } else {
      return false; // Uang kurang
    }
  }

  // Fungsi Pakai Item (Consume)
  void useItem(InventoryItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _hunter.inventory.remove(item);
    }
    _hunter.save();
    notifyListeners();
  }
}