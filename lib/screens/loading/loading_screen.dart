import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loadingScreen-bg.jpg"),
            fit: BoxFit.cover
            ),
        ),

        width: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text('Coffee So Good, Your tasts buds will love it', 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 1.2,
                fontFamily: 'poetsOne',
                fontSize: 50,
                
              ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text("The best coffee you'll ever taste",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'us_modern',
              ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15)
                  )
                ),
                child: Text('Get Started',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'poetsOne'
                ),)
                ),
            )
          ],
        ),
      )
    );
  }
}