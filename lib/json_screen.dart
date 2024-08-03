import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_provider.dart';

class JsonDisplayScreen extends StatelessWidget {
  const JsonDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted JSON'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _savePdf(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await _sharePdf(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ImageTakenProvider>(
          builder: (context, imageTakenProvider, child) {
            String prettyJson = const JsonEncoder.withIndent('  ')
                .convert(jsonDecode(imageTakenProvider.jsonDataText));

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Extracted JSON:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    prettyJson,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    final imageTakenProvider =
        Provider.of<ImageTakenProvider>(context, listen: false);
    final pdf = pw.Document();
    String prettyJson = const JsonEncoder.withIndent('  ')
        .convert(jsonDecode(imageTakenProvider.jsonDataText));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(prettyJson),
          );
        },
      ),
    );

    // Request permission to access external storage
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Get the external storage directory
      final directory = Directory('/storage/emulated/0/Documents/PDF');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File('${directory.path}/extracted_json.pdf');
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Permission denied')));
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    final imageTakenProvider =
        Provider.of<ImageTakenProvider>(context, listen: false);
    final pdf = pw.Document();
    String prettyJson = const JsonEncoder.withIndent('  ')
        .convert(jsonDecode(imageTakenProvider.jsonDataText));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(prettyJson),
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'extracted_json.pdf');
  }
}
