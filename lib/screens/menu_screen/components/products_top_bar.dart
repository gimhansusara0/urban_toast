import 'package:flutter/material.dart';

class ProductsTopBar extends StatelessWidget {
  const ProductsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text('Menu', style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),),
        ),
         Padding(
           padding: const EdgeInsets.all(20.0),
           child: Container(
                   width: double.infinity,
                   height: 100,
                   decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage('https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/hot_chocolate_78843_16x9.jpg'),
                    fit: BoxFit.cover,
                   ),
                    borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor
                   ),
                 ),
         )
      ],
    );

  }
}