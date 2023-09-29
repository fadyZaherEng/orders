// ignore_for_file: avoid_print, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
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
    super.initState();
    pdf.addPage(
      pw.Page(build: (ctx) {
        return pw.Center(
          child: pw.Image(pw.MemoryImage(widget.image)),
        );
      },
      ),
    );
    if(SharedHelper.get(key: 'd')!=null) {
      OrdersHomeCubit.get(context).modeChange();
      SharedHelper.remove(key: 'd');
    }
    //savePdf();
    print(pdf.document);
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
        listener:(context,state){},
        builder:(context,state){
          return Scaffold(
            body: SafeArea(
              child: showOrders(),
            ),
          );
        },
    );
  }

  Widget showOrders() {
    return PdfPreview(
      build: (format) => pdf.save(),
    );
  }
}
