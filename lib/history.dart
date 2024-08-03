import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImagePaths();
  }

  Future<void> _loadImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePaths = prefs.getStringList('imagePaths') ?? [];
    });
  }

  void _showFullImage(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(5),
          backgroundColor: Colors.grey,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Images Used'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: imagePaths.isEmpty
            ? Center(child: Text('No images found'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 images per row
                  crossAxisSpacing: 8.0, // Spacing between images
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullImage(imagePaths[index]),
                    child: Image.file(
                      File(imagePaths[index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
