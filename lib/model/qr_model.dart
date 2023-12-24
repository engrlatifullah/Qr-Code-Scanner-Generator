import 'package:cloud_firestore/cloud_firestore.dart';


class QrModel {

  String ? qrId;
  String ? itemName;
  String ? employeeName;
  String ? category;
  String ? qrCode;
  bool ? isUsed;
  String ? dateTime;

  QrModel({this.qrId,this.category,this.qrCode,this.isUsed,  this.dateTime, this.employeeName,this.itemName});

  Map<String , dynamic> toMap(){
    return {
      "qrId" : qrId,
      "category" : category,
      "qrCode" : qrCode,
      "isUsed" : isUsed,
      "employeeName" : employeeName,
      "itemName" : itemName,
      "dateTime" : dateTime
    };
  }

  factory QrModel.fromDoc(DocumentSnapshot documentSnapshot) {

    return QrModel(
      qrId: documentSnapshot["qrId"],
      qrCode: documentSnapshot["qrCode"],
      isUsed: documentSnapshot["isUsed"],
      category: documentSnapshot["category"],
        employeeName: documentSnapshot["employeeName"],
        itemName: documentSnapshot["itemName"],
        dateTime: documentSnapshot["dateTime"]
    );
  }

}