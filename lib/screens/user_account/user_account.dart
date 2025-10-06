import 'package:flutter/material.dart';
import 'package:urban_toast/screens/user_account/components/Item.dart';

class MyUserAccount extends StatelessWidget {
  const MyUserAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _portraitBuilder(context);
        } else {
          return _landscapeBuilder(context);
        }
      },
    );
  }
}

Widget _portraitBuilder(BuildContext context) {
  return SingleChildScrollView(
    child: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
    height: MediaQuery.of(context).size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.network(
            'https://i.pinimg.com/736x/51/f1/c4/51f1c4cf7b732a99471d0beca326d666.jpg',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Lewis Hamilton',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
      ],
    ),
    ),
    
    SizedBox(
    height: 400,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         
          UserItems(icon: Icon(Icons.phone), text: '+23 087226272'),
          UserItems(icon: Icon(Icons.email), text: 'lewis@gmail.com'),
          UserItems(icon: Icon(Icons.credit_card), text: 'Payment Methods'),
          UserItems(icon: Icon(Icons.history), text: 'Order History'),
          UserItems(icon: Icon(Icons.logout), text: 'Logout'),
        ],
      ),
    ),
    )
    
    
        ],
      )
    ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  return SafeArea(
    child: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
    
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    'https://i.pinimg.com/736x/51/f1/c4/51f1c4cf7b732a99471d0beca326d666.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lewis Hamilton',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
    
          // Right side - User items
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    UserItems(icon: Icon(Icons.phone), text: '+23 087226272'),
                    SizedBox(height: 10,),
                    UserItems(icon: Icon(Icons.email), text: 'lewis@gmail.com'),
                    SizedBox(height: 10,),
                    UserItems(icon: Icon(Icons.credit_card), text: 'Payment Methods'),
                    SizedBox(height: 10,),
                    UserItems(icon: Icon(Icons.history), text: 'Order History'),
                    SizedBox(height: 10,),
                    UserItems(icon: Icon(Icons.logout), text: 'Logout'),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
