import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/screens/home_screen/qr_code_generator/qr_code_generator.dart';
import 'package:qrcode/screens/home_screen/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:qrcode/screens/home_screen/widget/card_widget.dart';
import 'package:qrcode/widget/toast.dart';

import '../../model/qr_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentDate = DateTime.now();
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');

  handleScannedQRCode(String scanCode) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("qrCodes").get();
      for (var i in snapshot.docs) {
        QrModel qrModel = QrModel.fromDoc(i);
        if (qrModel.qrCode! == scanCode &&
            qrModel.dateTime == formattedDate.format(DateTime.now()) &&
            qrModel.isUsed == false) {
          successToast(
              "QrCode is Matched\n Item Name : ${qrModel.itemName}\n Created By : ${qrModel.employeeName}\n Date Time : ${qrModel.dateTime}");

          await FirebaseFirestore.instance
              .collection("qrCodes")
              .doc(qrModel.qrId)
              .update({'isUsed': true});
        } else if (qrModel.qrCode! == scanCode &&
            qrModel.isUsed == true &&
            qrModel.dateTime == formattedDate.format(DateTime.now())) {
          errorToast("QrCode is Used");
        } else if (qrModel.qrCode! == scanCode &&
            qrModel.dateTime != formattedDate.format(DateTime.now())) {
          errorToast("QrCode is Expired");
        } else {
          errorToast("QrCode is not found");
        }
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("QR Code Scanner"),
          actions: [
            IconButton(
              onPressed: () async {

                await generatePDF();
              },
              icon: const Icon(Icons.print),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CardWidget(
                    title: "QR Code Scanner",
                    icon: Icons.qr_code_scanner_outlined,
                    onTap: () async {
                      await BarcodeScanner.scan().then((codeScanner) {
                        handleScannedQRCode(codeScanner.rawContent);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CardWidget(
                    title: "QR Code Generator",
                    icon: Icons.qr_code,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const QrCodeGenerator();
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CardWidget(
                    title: "View QR Codes",
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const QrCodeViewer();
                      }));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> generatePDF() async {
  final pdf = pw.Document(pageMode: PdfPageMode.fullscreen, compress: true);

  QuerySnapshot firebaseData = await FirebaseFirestore.instance
      .collection("qrCodes")
      .where("isUsed", isEqualTo: false)
      .get();
  final List<QrModel> qr = [];

  for (int pageIndex = 0; pageIndex < firebaseData.docs.length; pageIndex++) {
    QrModel qrModel = QrModel.fromDoc(firebaseData.docs[pageIndex]);
    qr.add(qrModel);
  }

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return
            pw.GridView(
              crossAxisCount: 3, // Display two items in one row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children: qr.map((e){
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.BarcodeWidget(
                      data: e.qrCode!,
                      barcode: pw.Barcode.qrCode(),
                      height: 100,
                      width: 100,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text("Item Name: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(e.itemName!),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text("Created By: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(e.employeeName!),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text("Expiry Date: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(e.dateTime!),
                      ],
                    ),

                  ],
                );
              }).toList(),

          );
        }

    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}






