import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoCard extends StatelessWidget {
  final double height_val;
  final Alignment alignment;

  PromoCard({
    super.key,
    this.height_val = 220,
    this.alignment = Alignment.center,
  });

  final List<Map<String, String>> imgList = [
    {
      'path': 'assets/images/promo-1.jpg',
      'label': 'Freshly Brewed Delights',
    },
    {
      'path': 'assets/images/promo-2.jpg',
      'label': 'New Arrivals Every Week',
    },
    {
      'path': 'assets/images/promo-3.webp',
      'label': 'Grab Your Morning Energy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: CarouselSlider(
        options: CarouselOptions(
          height: height_val,
          autoPlay: true,
          enlargeCenterPage: false, 
          enableInfiniteScroll: true,
          viewportFraction: 0.88,
          padEnds: true,
          autoPlayCurve: Curves.easeInOut,
          autoPlayAnimationDuration: const Duration(milliseconds: 900),
        ),
        items: imgList.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6), // spacing between cards
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item['path']!,
                        fit: BoxFit.cover,
                        alignment: alignment,
                      ),
                      // Gradient overlay
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      // Bottom-left text
                      Positioned(
                        bottom: 12,
                        left: 15,
                        child: Text(
                          item['label']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
