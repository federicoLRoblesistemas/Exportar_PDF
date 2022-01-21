import 'dart:io';

import 'package:exportacion_app/src/helpers/pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  final TextEditingController text1Controller = TextEditingController();
  final TextEditingController text2Controller = TextEditingController();
  final TextEditingController text3Controller = TextEditingController();
  final encabezado = ['Descripcion', 'Cantidad', 'Precio'];

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<String>> miLista = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportacion App'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Spacer(),
              TextField(
                controller: text1Controller,
              ),
              TextField(
                controller: text2Controller,
              ),
              TextField(
                controller: text3Controller,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        List<String> listaTemp = [];
                        listaTemp.add(text1Controller.text);
                        text1Controller.clear();
                        listaTemp.add(text2Controller.text);
                        text2Controller.clear();
                        listaTemp.add(text3Controller.text);
                        text3Controller.clear();
                        miLista.add(listaTemp);
                      },
                      child: const Text('Agregar')),
                  TextButton(
                      onPressed: () {
                        (miLista.isNotEmpty) ? creaPdf(miLista, encabezado) : null;
                      },
                      child: const Text('Exportar')),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> creaPdf(List<List<String>> miLista, List<String> encabezado) async {
  Directory tempDir = await getTemporaryDirectory();
  final file = File("${tempDir.path}/miPDF.pdf");
  final pdf = await generarPDF(miLista, encabezado);
  await file.writeAsBytes(pdf);
  //await writeToFile(pdf, tempPath);
  const String texto = 'Te paso el PDF !!';

  await Share.shareFiles([file.path], text: texto);
}

// Future<void> writeToFile(ByteData? data, String fullpath) async {
//   final buffer = data!.buffer;
//   await File(fullpath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
// }
