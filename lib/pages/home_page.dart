import 'package:codigo4_qr/pages/scanner_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScannerPage()));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Listado general",
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            // color: Colors.amber,
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
                        "Carta del menú de la esquina askdjhs askdnsaldkn ",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "12/06/2023",
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
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
