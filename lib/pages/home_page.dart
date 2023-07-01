import 'dart:io';
import 'dart:typed_data';
import 'package:codigo4_qr/pages/dashboard_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo4_qr/data/data.dart';
import 'package:codigo4_qr/models/qr_model.dart';
import 'package:codigo4_qr/pages/scanner_page.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference qrCollection =
      FirebaseFirestore.instance.collection("qr_collection");

  void showDetailQR(QrModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Detalle QR",
              ),
              const Divider(),
              Row(
                children: [
                  Text(
                    "Descripción: ",
                  ),
                  Expanded(
                    child: Text(model.description),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    "Fecha: ",
                  ),
                  Expanded(
                    child: Text(
                      model.datetime.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 120,
                width: 120,
                child: QrImageView(
                  data: model.qr,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<QrModel>> getDataQR() async {
    QuerySnapshot collection = await qrCollection.get();
    List<QueryDocumentSnapshot> docs = collection.docs;
    List<QrModel> qrList = [];
    // for (var item in docs) {
    //   Map<String, dynamic> data = item.data() as Map<String, dynamic>;
    //   QrModel model = QrModel.fromJson(data);
    //   qrList.add(model);
    // }
    qrList = docs
        .map((e) => QrModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return qrList;
  }

  exportExcel() async {
    List<QrModel> data = await getDataQR();
    excel.Excel myExcel = excel.Excel.createExcel();
    excel.Sheet? sheet = myExcel.sheets[myExcel.getDefaultSheet()];

    //Cabeceras
    sheet!
        .cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = "ID";
    sheet
        .cell(excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = "Descripción";
    sheet
        .cell(excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = "Fecha";
    sheet
        .cell(excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = "QR";

    // Data General

    for (int i = 0; i < data.length; i++) {
      sheet
          .cell(
              excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = i + 1;
      sheet
          .cell(
              excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = data[i].description;
      sheet
          .cell(
              excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
          .value = data[i].datetime.toString();
      sheet
          .cell(
              excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
          .value = data[i].qr;
    }

    Directory directory = await getApplicationDocumentsDirectory();

    List<int>? bytes = myExcel.save();

    File fileExcel = File("${directory.path}/reporteExcel.xlsx");
    fileExcel.createSync(recursive: true);
    fileExcel.writeAsBytesSync(bytes!);
    OpenFilex.open("${directory.path}/reporteExcel.xlsx");
  }

  exportPdf() async {
    List<QrModel> data = await getDataQR();

    ByteData byteData = await rootBundle.load("assets/images/vw.png");
    Uint8List bytesLogo = byteData.buffer.asUint8List();

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  pw.MemoryImage(bytesLogo),
                  height: 60,
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Teléfono: 34232343",
                    ),
                    pw.Text(
                      "Dirección: Av Lima 123",
                    ),
                    pw.Text(
                      "E-mail: mandarina@gmail.com",
                    ),
                    pw.Text(
                      "Contácto: Juan Lopez",
                    ),
                  ],
                ),
              ],
            ),
            pw.ListView.builder(
              itemCount: data.length,
              itemBuilder: (pw.Context context, int index) {
                return pw.Container(
                  margin: const pw.EdgeInsets.all(6.0),
                  padding: const pw.EdgeInsets.all(8.0),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(8.0),
                    border: pw.Border.all(
                      width: 0.9,
                      color: PdfColors.black,
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("ID: "),
                          pw.Text("${index + 1}"),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Descripción: "),
                          pw.Text(data[index].description),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Fecha: "),
                          pw.Text(data[index].datetime.toString()),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("QR: "),
                          pw.Expanded(
                            child: pw.Text(data[index].qr),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ];
        },
      ),
    );

    Uint8List bytes = await pdf.save();
    Directory directory = await getApplicationDocumentsDirectory();
    File pdfFile = File("${directory.path}/reportePdf.pdf");
    pdfFile.createSync(recursive: true);
    pdfFile.writeAsBytesSync(bytes);
    OpenFilex.open("${directory.path}/reportePdf.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScannerPage()))
              .then((value) {
            setState(() {});
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Listado general",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardPage(),
                ),
              );
            },
            icon: Icon(
              Icons.bar_chart,
            ),
          ),
          IconButton(
            onPressed: () {
              exportExcel();
            },
            icon: Icon(Icons.import_export),
          ),
          IconButton(
            onPressed: () {
              exportPdf();
            },
            icon: Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: Data().getQrListLength(),
      //   itemBuilder: (BuildContext context, int index) {
      //     // Map qrData = Data().qrList[index];
      //     QrModel model = Data().getValue(index);

      //     return Container(
      //       margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      //       decoration: BoxDecoration(
      //         border: Border.all(
      //           width: 1,
      //           color: Colors.black.withOpacity(0.1),
      //         ),
      //         borderRadius: BorderRadius.circular(12.0),
      //       ),
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   model.description,
      //                   style: TextStyle(
      //                     fontSize: 15.0,
      //                     fontWeight: FontWeight.normal,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 4.0,
      //                 ),
      //                 Text(
      //                   model.datetime.toString(),
      //                   style: TextStyle(
      //                     fontSize: 12.0,
      //                     color: Colors.black54,
      //                     fontWeight: FontWeight.normal,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.qr_code),
      //             onPressed: () {},
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),

      /// Datos desde Firebase - Future

      // body: FutureBuilder(
      //   future: qrCollection.get(),
      //   builder: (BuildContext context, AsyncSnapshot snap) {
      //     if (snap.hasData) {
      //       QuerySnapshot collection = snap.data;
      //       List<QueryDocumentSnapshot> docs = collection.docs;
      //       return ListView.builder(
      //         itemCount: docs.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           Map<String, dynamic> data =
      //               docs[index].data() as Map<String, dynamic>;

      //           QrModel model = QrModel.fromJson(data);

      //           return Container(
      //             margin: const EdgeInsets.symmetric(
      //                 horizontal: 12.0, vertical: 10),
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 width: 1,
      //                 color: Colors.black.withOpacity(0.1),
      //               ),
      //               borderRadius: BorderRadius.circular(12.0),
      //             ),
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         model.description,
      //                         style: TextStyle(
      //                           fontSize: 15.0,
      //                           fontWeight: FontWeight.normal,
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         height: 4.0,
      //                       ),
      //                       Text(
      //                         model.datetime.toString(),
      //                         style: TextStyle(
      //                           fontSize: 12.0,
      //                           color: Colors.black54,
      //                           fontWeight: FontWeight.normal,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 IconButton(
      //                   icon: Icon(Icons.qr_code),
      //                   onPressed: () {},
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     return CircularProgressIndicator();
      //   },
      // ),

      /// Datos desde Firebase - Stream
      ///

      body: StreamBuilder(
        stream: qrCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            List<QueryDocumentSnapshot> docs = collection.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                    docs[index].data() as Map<String, dynamic>;

                QrModel model = QrModel.fromJson(data);

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.description,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              model.datetime.toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.share(model.description, subject: "QR Data: ");
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.qr_code),
                        onPressed: () {
                          showDetailQR(model);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
