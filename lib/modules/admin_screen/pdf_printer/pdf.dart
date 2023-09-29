// ignore_for_file: avoid_print, must_be_immutable
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPrintOrdersScreen extends StatefulWidget {
  List<Uint8List?> widgets;
  PdfPrintOrdersScreen({required this.widgets});

  @override
  State<PdfPrintOrdersScreen> createState() => _PdfPrintOrdersScreenState();
}

class _PdfPrintOrdersScreenState extends State<PdfPrintOrdersScreen> {
  final pdf = pw.Document();

  @override
  void initState() {
    // TODO: implement initState
    print(widget.widgets);
    super.initState();
    widget.widgets.forEach((image) {
      pdf.addPage(
        pw.Page(build: (ctx) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(image!)),
          );
        }),
      );
    });
    //savePdf();
    print(pdf.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: showOrders(),
      ),
    );
  }

  Widget showOrders() {
    return PdfPreview(
      build: (format)async =>await pdf.save(),
    );
  }
}
