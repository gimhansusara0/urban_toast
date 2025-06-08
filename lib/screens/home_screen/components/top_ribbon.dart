import 'package:flutter/material.dart';

class TopRibbon extends StatelessWidget {
  const TopRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome Ranuja!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),),
              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.notifications,
                    color: Theme.of(context).primaryColor,),
                    
                    Icon(Icons.shopping_cart,
                    color: Theme.of(context).primaryColor,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}