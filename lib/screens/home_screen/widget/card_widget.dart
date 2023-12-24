import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final IconData icon;

  const CardWidget({
    super.key,
    this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon!,
                  size: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
