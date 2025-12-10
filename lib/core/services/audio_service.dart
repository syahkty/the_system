import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  // Matikan fitur log agar tidak berisik di console
  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  // 1. Suara Naik Level
  Future<void> playLevelUp() async {
    await _player.stop(); // Hentikan suara sebelumnya jika ada
    await _player.play(AssetSource('sounds/levelup.mp3'));
  }

  // 2. Suara Misi Selesai
  Future<void> playQuestComplete() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/complete.mp3'));
  }

  // 3. Suara Transaksi (Dapat Gold / Belanja)
  Future<void> playKaChing() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/coins.mp3'));
  }
}