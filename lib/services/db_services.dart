import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrcode/model/qr_model.dart';

class DbServices {
  static uploadData({
    BuildContext ? context,
    String? category,
    String? qrCode,
    String? employeeName,
    String? itemName,
    String ? dateTime
  }) async {
    try {
      EasyLoading.show(status: "Please wait");
      String docId = DateTime.now().microsecondsSinceEpoch.toString();
      QrModel qrModel = QrModel(
        qrId: docId,
        category: category,
        employeeName: employeeName,
        itemName: itemName,
        qrCode: qrCode, dateTime: dateTime,
        isUsed: false
      );
      await FirebaseFirestore.instance
          .collection("qrCodes")
          .doc(docId)
          .set(qrModel.toMap());
      EasyLoading.dismiss();
      EasyLoading.showSuccess("QR Code Generated");
    }
    on FirebaseException catch(e){
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }
}
