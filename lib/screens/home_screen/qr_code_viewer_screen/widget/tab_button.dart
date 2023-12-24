import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final VoidCallback  onTap;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  const TabButton({Key? key, required this.onTap, required this.backgroundColor, required this.textColor, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap ,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:backgroundColor
        ),
        child:  Center(
            child: Text(
              title,style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,color: textColor
            ),
            )
        ),
      ),
    );
  }
}
