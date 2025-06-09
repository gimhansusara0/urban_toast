import 'package:flutter/material.dart';

class UserItems extends StatelessWidget {
  final Icon icon;
  final String text;
  const UserItems({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),

      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(children: [icon, SizedBox(width: 10,),Text(text)]),
          SizedBox(width: 10,),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}
