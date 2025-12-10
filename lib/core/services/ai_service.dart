import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/quest_model.dart';
import '../constants/api_keys.dart';

class AiService {
  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ApiConstants.geminiApiKey,
    );
  }

  // Fungsi utama: Menerima curhat user -> Mengembalikan Daftar Misi
  Future<List<QuestModel>> generateQuests(String userGoal) async {
    // 1. Prompt Engineering (Mantra Pemanggil)
    final prompt = '''
      Anda adalah "The System", sebuah antarmuka RPG kehidupan nyata.
      User memiliki tujuan: "$userGoal".
      
      Tugas: Pecah tujuan tersebut menjadi 3-5 langkah/misi kecil yang konkret.
      
      Aturan Output:
      1. HANYA berikan output JSON murni. Jangan ada teks pembuka/penutup.
      2. Format JSON harus List of Objects:
      [
        {
          "title": "Nama Misi",
          "description": "Cara mengerjakan",
          "xp": 100,
          "difficulty": "Easy",
          "category": "INT"  <-- PILIH SATU DARI: STR, INT, ART, VIT, CHR
        }
      ]
      3. Difficulty options: Easy, Medium, Hard, Boss.
      4. XP range: Easy(50), Medium(100), Hard(200), Boss(500).
      5. Aturan Kategori Stats:
        - STR: Olahraga, Angkat beban, Lari.
        - INT: Coding, Belajar, Membaca, Logika.
        - ART: Musik, Gambar, Menulis, Desain.
        - VIT: Tidur, Minum air, Makan sehat, Meditasi.
        - CHR: Sosialisasi, Ngobrol, Presentasi.
      6. descripsi nya batas 25 kata 
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) return [];

      // 2. Pembersihan Data (Kadang AI menambahkan ```json di awal)
      String cleanJson = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // 3. Konversi JSON String -> List<QuestModel>
      final List<dynamic> jsonList = jsonDecode(cleanJson);

      // Menggunakan factory .fromJson yang sudah kita buat tadi
      return jsonList.map((json) => QuestModel.fromJson(json)).toList();

    } catch (e) {
      print("System Error: $e");
      // Jika error, kembalikan list kosong agar aplikasi tidak crash
      return [];
    }
  }
}