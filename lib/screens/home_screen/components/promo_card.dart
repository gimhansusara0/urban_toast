import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoCard extends StatelessWidget {

final List<String> imgList = [
    'https://i.ibb.co/ZRLBhqBF/carousel-item-1.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuy8nVIdf1DGWzOF21o0o4g1isRLvWweAq1A&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_q3RgbT5l5mBlVr4thFsw_wfe6ZPSDuTm1g&s',
  ];


  @override
  Widget build(BuildContext context) {
    return  CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
      items: imgList.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}