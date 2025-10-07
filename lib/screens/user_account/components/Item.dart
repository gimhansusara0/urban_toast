import 'package:flutter/material.dart';

class UserItems extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final Color? textColor;

  const UserItems({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.showEditIcon = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              icon,
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    color: textColor ?? Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ]),
            if (showEditIcon) const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
