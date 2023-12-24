import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const PrimaryButton({
    Key? key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo,
        ),
        child: const Center(
          child: Text(
            "Generate",style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,color: Colors.white
          ),
          )
        ),
      ),
    );
  }
}
