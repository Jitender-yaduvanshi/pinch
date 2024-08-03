import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'image_provider.dart';
import 'display.dart';
import 'history.dart';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Are you sure?', style: TextStyle(color: Colors.white)),
            content: const Text('Do You Want To Exit The App', style: TextStyle(color: Colors.white70)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.history_rounded),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen())),
            ),
            SizedBox(width: width * 0.03),
          ],
          centerTitle: true,
          title: const Text('Pick an Image'),
        ),
        body: Consumer<ImageTakenProvider>(
          builder: (context, imageProvider, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      imageProvider.image != null
                          ? Image.file(File(imageProvider.image!.path), height: height * 0.55, width: height * 0.5, fit: BoxFit.cover)
                          : const Text('No image selected.'),
                      if (imageProvider.isLoading) Positioned(
                        top: MediaQuery.of(context).size.height / 2 - 200,
                        left: MediaQuery.of(context).size.width / 2 - 13,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await imageProvider.pickImage(ImageSource.camera);
                      if (imageProvider.image != null) {
                        await imageProvider.imageDecode(imageProvider.image!.path);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayTextScreen(imagePath: imageProvider.image!.path))).then((_) {
                          imageProvider.clearImage();
                        });
                      }
                    },
                    child: const Text('Take a Photo'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await imageProvider.pickImage(ImageSource.gallery);
                      if (imageProvider.image != null) {
                        await imageProvider.imageDecode(imageProvider.image!.path);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayTextScreen(imagePath: imageProvider.image!.path))).then((_) {
                          imageProvider.clearImage();
                        });
                      }
                    },
                    child: const Text('Pick from Gallery'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
