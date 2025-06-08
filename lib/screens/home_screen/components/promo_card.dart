import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoCard extends StatelessWidget {
PromoCard({super.key});
final List<String> imgList = [
    'https://img.playbook.com/8LW0YP0JEWP4pXzvnpIHTBLzIjrVVLE-HifrNAFo2Fg/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzNhODJkNzc1/LWQxOWMtNDZiZi1h/NDQzLTk5NjZlYzE5/YTUzZg',
    'https://img.playbook.com/rck2gJxZm9Q4aGPk7EmBqQ08UtpGf07Tx0hOMtPto6w/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzVlMDdkMTgy/LWVlNzYtNDhhYy1h/NTJhLWQzNDU5ZTNm/OWVkYQ',
    'https://img.playbook.com/5CP5q40-eclPTwTZCZ7ss3rhTqkV2qOwGIYZJ4ipXSs/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljL2NhNWVmMjNi/LWEyYjktNDA4Ny05/YjRjLTVkODcwMmQ2/MTc4MQ',
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