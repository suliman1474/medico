import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final downloadUrl;
  const PdfViewer({super.key, required this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(
              downloadUrl,
            ),
          ),
        ],
      ),
    );
  }
}
