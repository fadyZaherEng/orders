import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            IconButton(
                onPressed: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ),
                  );
                  setState(() {
                    if (res is String) {
                      result = res;
                      print(result);
                    }
                  });
                },
                icon:const Icon(Icons.scanner)),
                const SizedBox(height: 50,),
                Text(result),
          ],
        ));
  }
}
