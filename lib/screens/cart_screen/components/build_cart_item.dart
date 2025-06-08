import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';

class CartItem extends StatelessWidget {
  final Product item;
  const CartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          item.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),

        title: Text(item.name),
        subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
            Text("1"),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
