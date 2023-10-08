// ignore_for_file: avoid_print, must_be_immutable
import 'package:flutter/material.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPrintOrdersScreen extends StatefulWidget {
  pw.Document pdf = pw.Document();
  PdfPrintOrdersScreen(this.pdf, {super.key});
  @override
  State<PdfPrintOrdersScreen> createState() => _PdfPrintOrdersScreenState();
}

class _PdfPrintOrdersScreenState extends State<PdfPrintOrdersScreen> {

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
      build: (format) async => await widget.pdf.save(),
    );
  }
}