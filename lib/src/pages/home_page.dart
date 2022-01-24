import 'dart:io';

import 'package:exportacion_app/src/helpers/pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  final TextEditingController textDescripcionController = TextEditingController();
  final TextEditingController textCantidadController = TextEditingController();
  final TextEditingController textValorController = TextEditingController();
  final encabezado = ['Descripcion', 'Cantidad', 'Precio'];

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0;
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
              const Text('Descripcion'),
              TextField(
                controller: textDescripcionController,
              ),
              const Text('Cantidad'),
              TextField(
                controller: textCantidadController,
              ),
              const Text('Valor'),
              TextField(
                controller: textValorController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        List<String> listaTemp = [];
                        listaTemp.add(textDescripcionController.text);
                        textDescripcionController.clear();
                        listaTemp.add(textCantidadController.text);
                        textCantidadController.clear();
                        listaTemp.add(textValorController.text);

                        miLista.add(listaTemp);
                        total += double.tryParse(textValorController.text)!;
                        textValorController.clear();
                      },
                      child: const Text('Agregar')),
                  TextButton(
                      onPressed: () {
                        (miLista.isNotEmpty) ? creaPdf(miLista, encabezado, total) : null;
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

Future<void> creaPdf(List<List<String>> miLista, List<String> encabezado, double total) async {
  Directory tempDir = await getTemporaryDirectory();
  final file = File("${tempDir.path}/miPDF.pdf");
  final pdf = await generarPDF(miLista, encabezado, total);
  await file.writeAsBytes(pdf);
  //await writeToFile(pdf, tempPath);
  const String texto = 'Te paso el PDF !!';

  await Share.shareFiles([file.path], text: texto);
}

// Future<void> writeToFile(ByteData? data, String fullpath) async {
//   final buffer = data!.buffer;
//   await File(fullpath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
// }
