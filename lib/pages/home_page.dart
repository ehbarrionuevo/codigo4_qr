import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo4_qr/data/data.dart';
import 'package:codigo4_qr/models/qr_model.dart';
import 'package:codigo4_qr/pages/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    qrCollection.get().then((value) {
      print(value.size);
    });

    //Stream

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
