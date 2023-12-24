import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/services/db_services.dart';
import 'package:qrcode/widget/primary_button.dart';

import '../../../widget/custom_input.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController employeeController = TextEditingController();

  String? qrCodeData;
  List<String> categories = ['Foods', 'Drinks'];
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');

  String? category;

  generateQRCodeData() {
    final String uniqueString =
        DateTime.now().microsecondsSinceEpoch.toString() +
            category! +
            employeeController.text;

    setState(() {
      qrCodeData = uniqueString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              qrCodeData == null
                  ? const Text(
                      "Enter Details To Generate Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    )
                  : Center(
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: QrImageView(data: qrCodeData!)),
                    ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: const [
                      DropdownMenuItem(
                        value: "Foods",
                        child: Text("Foods"),
                      ),
                      DropdownMenuItem(
                        value: "Drinks",
                        child: Text("Drinks"),
                      ),
                    ],
                    value: category,
                    hint: const Text("Select category"),
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: itemNameController,
                title: "Item name",
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: employeeController,
                title: "Employee name",
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                title: "Generate QR",
                onTap: () async {
                  if (category == null || category == '') {
                    EasyLoading.showError("Category is required");
                  } else if (employeeController.text.isEmpty) {
                    EasyLoading.showError("Employee Name is required");
                  } else if (itemNameController.text.isEmpty) {
                    EasyLoading.showError("Employee Name is required");
                  } else {
                    generateQRCodeData();
                    await DbServices.uploadData(
                      context: context,
                      qrCode: qrCodeData,
                      itemName: itemNameController.text,
                      category: category,
                      employeeName: employeeController.text,
                      dateTime: formattedDate.format(DateTime.now()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
