import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/model/qr_model.dart';

import '../qr_details_screen/qr_details_screen.dart';

class DrinkTab extends StatelessWidget {
  const DrinkTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("qrCodes")
            .where("category", isEqualTo: "Drinks")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("QR Code is not Available"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              QrModel qrModel = QrModel.fromDoc(snapshot.data!.docs[index]);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    qrModel.itemName!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return  QrDetailsScreen(qrModel: qrModel,);
                      }));
                    },
                    child: const Text(
                        "View QR"
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
