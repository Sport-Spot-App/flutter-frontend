import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CourtCard extends StatefulWidget {
  final List<String> imageUrlList;
  final String name;
  final String type;
  final String price;

  const CourtCard({
    super.key,
    required this.imageUrlList,
    required this.name,
    required this.type,
    required this.price,
  });
  
  @override
  State<CourtCard> createState() => _CourtCardState();
}

class _CourtCardState extends State<CourtCard> {
  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court Images
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged:(index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: widget.imageUrlList.map((item) => Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
              ),
            )).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrlList.asMap().entries.map((entry) {
              return Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (
                    Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black
                  ).withOpacity(currentIndex == entry.key ? 0.9 : 0.4),
                ),
              );
            }).toList(),
          ),
          // Court Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.type,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 100, 100, 100),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${widget.price}/hora',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}