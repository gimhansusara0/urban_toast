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
              const Text(
                'Welcome Lewis!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
