import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/model/qr_model.dart';
import 'package:qrcode/screens/home_screen/qr_code_viewer_screen/tabs/drink_tab.dart';
import 'package:qrcode/screens/home_screen/qr_code_viewer_screen/tabs/food_tab.dart';
import 'package:qrcode/screens/home_screen/qr_code_viewer_screen/widget/tab_button.dart';

class QrCodeViewer extends StatefulWidget {
  const QrCodeViewer({Key? key}) : super(key: key);

  @override
  State<QrCodeViewer> createState() => _QrCodeViewerState();
}

class _QrCodeViewerState extends State<QrCodeViewer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TabButton(
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                        backgroundColor:
                            _currentIndex == 0 ? Colors.indigo : Colors.transparent,
                        textColor:
                            _currentIndex == 0 ? Colors.white : Colors.black, title: 'Food',),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TabButton(
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        backgroundColor:
                            _currentIndex == 1 ? Colors.indigo : Colors.transparent,
                        textColor:
                            _currentIndex == 1 ? Colors.white : Colors.black, title: 'Drink',),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _currentIndex == 0 ? const FoodTab() :const DrinkTab(),
          ],
        ),
      ),
    );
  }
}
