import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_share/flutter_share.dart';

class PDFScreen extends StatefulWidget {
  PDFScreen(this.pathPDF);
  final String pathPDF;
  @override
  State<StatefulWidget> createState() => new _PDFScreenState(pathPDF:pathPDF);
}

class _PDFScreenState extends State<PDFScreen> {
  _PDFScreenState({this.pathPDF});
  final String pathPDF;

  Future<void> shareFile() async {
    await FlutterShare.shareFile(
      title: 'Resume Share',
      filePath: pathPDF,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text("Resume PDF View"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                shareFile();
              },
            ),
          ],
        ),
        path: pathPDF);
  }
}