import 'package:flutter/material.dart';

class ProductsTopBar extends StatelessWidget {
  const ProductsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: (){
            }, icon: Icon(Icons.arrow_back)),
        
            Text('Menu', style: TextStyle(
              fontSize: 24
            ),)
        ,
          ],
        ),
         Padding(
           padding: const EdgeInsets.all(20.0),
           child: Container(
                   width: double.infinity,
                   height: 100,
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor
                   ),
                 ),
         )
      ],
    );

  }
}