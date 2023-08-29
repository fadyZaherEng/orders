// ignore_for_file: avoid_print, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintOrderScreen extends StatefulWidget {
  Uint8List image;

  PrintOrderScreen(this.image, {super.key});

  @override
  State<PrintOrderScreen> createState() => _PrintOrderScreenState();
}

class _PrintOrderScreenState extends State<PrintOrderScreen> {
  final pdf = pw.Document();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdf.addPage(
      pw.Page(build: (ctx) {
        return pw.Center(
          child: pw.Image(pw.MemoryImage(widget.image)),
        );
      }),
    );
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
      build: (format) => pdf.save(),
    );
  }
}
