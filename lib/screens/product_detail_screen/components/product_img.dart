import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: NetworkImage('https://www.foodandwine.com/thmb/V1OEgtLQGUv_w2Fvm40WMLsJ4rk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Indulgent-Hot-Chocolate-FT-RECIPE0223-fd36942ef266417ab40440374fc76a15.jpg'),
          fit: BoxFit.cover,
          ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white,)),
                Icon(Icons.add, color: Colors.white,)
              ],
            ),
          ),
          GlassmorphicContainer(
            width: double.infinity, 
            height: 100, 
            borderRadius: 25, 
             linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00000).withOpacity(0.1),
                Color(0xFF00000).withOpacity(0.05),
              ],
              stops: [
                0.1,
                1,
              ]),
            border: 0, 
            blur: 20, 
           borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withOpacity(0.5),
                Color((0xFFFFFFFF)).withOpacity(0.5),
            ],
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Text('Cappuchino',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),
            Text('Hot Coffee',
            style: TextStyle(
              color: Colors.white
            ),),
          
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: SizedBox(
          width: 60,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                    height: 40,
                    width: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Icon(Icons.coffee,color: Theme.of(context).primaryColor)),
                   Container(
                    height: 40,
                    width: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor,)),
                 ],
               ),
               Container(
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColorDark,
                ),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star,color: Theme.of(context).primaryColor,),
                    Text('4.6')
                  ],
                 ),
               )
            ],
          ),
        ),
      )


    ],
  ),
  ),



        ],
      ),
    );
  }
}