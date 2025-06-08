import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';

class ProductContentLandscape extends StatefulWidget {
  final Product product;
  const ProductContentLandscape({super.key, required this.product});

  @override
  State<ProductContentLandscape> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContentLandscape> {
  String selectedSize = 'S';
  final sizes = ['S', 'M', 'L'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 15,
            color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white
          ),),


            SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Text(widget.product.description, style: TextStyle(
              fontSize: 15,
              decoration: TextDecoration.none,
              color:  Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white
            
            ),),
          )
,
          SizedBox(height: 15,),
          Text('Size',
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 18,
            color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white
          )
          ),


          SizedBox(height: 20,),


          Row(
            children: sizes.map((size) {
              final isSelected = size == selectedSize;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => selectedSize = size),
                  child: Container(
                    width: 100,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.transparent : Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: Color(0xFFD48B5C), width: 2)
                          : null,
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 28,
                        decoration: TextDecoration.none,
                        color: isSelected ? Color(0xFFD48B5C) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),


          SizedBox(height: 40,),

          Text('\$${widget.product.price.toStringAsFixed(2)}' , style: TextStyle(
            fontSize: 25,
            decoration: TextDecoration.none,
            color:  Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white
          ),),

           SizedBox(height: 20,)
          ,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){}, child: Text('Order Now'))),
          )









        ],
      ),
    );
  }
}
