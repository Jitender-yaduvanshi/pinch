import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'image_provider.dart';
import 'json_screen.dart';

class DisplayTextScreen extends StatelessWidget {
  final String imagePath;

  DisplayTextScreen({super.key, required this.imagePath});

  Future<void> _saveImage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> imagePaths = prefs.getStringList('imagePaths') ?? [];
    imagePaths.add(imagePath);
    await prefs.setStringList('imagePaths', imagePaths);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final imageTakenProvider =
        Provider.of<ImageTakenProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await imageTakenProvider.imageDecode(imagePath);
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Parsed Text'),
        actions: [
          GestureDetector(
            child: const Icon(Icons.save),
            onTap: () => _saveImage(context),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          GestureDetector(
            child: const Text('JSON'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JsonDisplayScreen(),
                ),
              );
            },
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: Consumer<ImageTakenProvider>(
        builder: (context, imageTakenProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Extracted Text:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(imageTakenProvider.extractedText),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
