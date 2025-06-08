import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  const Search_Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
  child: SizedBox(
    height: 40,
    child: TextField(
      
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        fillColor: Theme.of(context).cardColor,
        filled: true,
         contentPadding: EdgeInsets.only(top: 10),
        hintText: 'Search coffee',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  ),
);
  }
}
