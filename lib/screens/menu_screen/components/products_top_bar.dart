import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductsTopBar extends StatelessWidget {
  const ProductsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bannerItems = [
      {
        'url': 'https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/hot_chocolate_78843_16x9.jpg',
        'label': 'Hot Chocolate Bliss',
      },
      {
        'url': 'https://img.freepik.com/free-photo/top-view-coffee-cup-with-beans_23-2148252255.jpg',
        'label': 'Freshly Ground Perfection',
      },
      {
        'url': 'https://img.freepik.com/free-photo/coffee-with-biscuits_144627-32512.jpg',
        'label': 'Cozy Moments Await',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menu title Cart icon row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                onPressed: () {
                  
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Carousel banner
        CarouselSlider(
          options: CarouselOptions(
            height: 140,
            autoPlay: true,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            viewportFraction: 0.9,
            padEnds: true,
            autoPlayCurve: Curves.easeInOut,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          ),
          items: bannerItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          item['url']!,
                          fit: BoxFit.cover,
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
                        // Bottom-left label
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
      ],
    );
  }
}
