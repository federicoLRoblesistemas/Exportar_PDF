import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generarPDF(List<List<String>> miLista, List<String> encabezado, double total) async {
  final pw.Document doc = pw.Document();

  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.SizedBox();
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // decoration: const pw.BoxDecoration(
            //     border: pw.BoxBorder(
            //         bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Text('Portable Document Format', style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Table.fromTextArray(context: context, border: null, headerAlignment: pw.Alignment.centerLeft, data: <List<dynamic>>[
              encabezado,
              for (int i = 0; i < miLista.length; i++)
                [
                  for (var e = 0; e < miLista[i].length; e++)
                    {
                      miLista[i][e],
                    }.reduce((value, element) => value + element).replaceAll('{', '')
                ],
            ]),
            pw.Paragraph(text: ""),
            pw.Paragraph(text: "Subtotal: $total"),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));

  return doc.save();
}
