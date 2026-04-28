import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/ingredient_checklist.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  bool _showIngredients = false;
  final List<String> _availableIngredients = [
    'Ayam',
    'Bawang',
    'Cabai',
    'Tomat',
    'Telur',
    'Kecap',
    'Mentega',
    'Bawang Bombay',
    'Kunyit',
    'Ketumbar',
    'Garam',
  ];
  List<String> _selectedIngredients = [];

  Future<List<String>> _simulateAIAnalysis(File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final fileName = imageFile.path.split('/').last;
    final hash = fileName.hashCode.abs();
    final randomSeed = hash % 100;

    List<String> suggested = ['Ayam'];
    if (randomSeed % 2 == 0) suggested.add('Bawang');
    if (randomSeed % 3 == 0) suggested.add('Cabai');
    if (randomSeed % 4 == 0) suggested.add('Tomat');
    if (randomSeed % 5 == 0) suggested.add('Telur');
    if (randomSeed % 6 == 0) suggested.add('Kecap');
    if (randomSeed % 7 == 0) suggested.add('Mentega');
    if (randomSeed % 8 == 0) suggested.add('Bawang Bombay');
    if (randomSeed % 9 == 0) suggested.add('Kunyit');
    if (randomSeed % 10 == 0) suggested.add('Ketumbar');
    if (randomSeed % 11 == 0) suggested.add('Garam');

    if (suggested.length < 3) suggested.addAll(['Bawang', 'Cabai']);
    return suggested.toSet().toList();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _showIngredients = false;
    });

    LoadingDialog.show(context, 'Menganalisis gambar menggunakan AI...');
    final suggested = await _simulateAIAnalysis(File(pickedFile.path));
    LoadingDialog.hide(context);

    setState(() {
      _selectedIngredients = suggested;
      _showIngredients = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI mendeteksi: ${suggested.join(", ")}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _searchRecipes() {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih minimal 1 bahan!')));
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: _selectedIngredients,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'AI Scanner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Preview Gambar Modern
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada gambar',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Aksi Modern
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pilih Galeri'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Hasil AI
            if (_showIngredients)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bahan Terdeteksi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    IngredientChecklist(
                      ingredients: _availableIngredients,
                      selectedIngredients: _selectedIngredients,
                      onChanged: (list) =>
                          setState(() => _selectedIngredients = list),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _searchRecipes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Cari Resep',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
