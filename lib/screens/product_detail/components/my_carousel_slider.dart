import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';

class MyCarousel extends StatefulWidget {
  Product product;

  MyCarousel({required this.product});

  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 1,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  autoPlay: false,
                ),
                itemCount: widget.product.images!.length,
                itemBuilder: (context, index, int) {
                  return CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '${widget.product.images![index]}',
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.product.images!.map((url) {
                  int index = widget.product.images!.indexOf(url);
                  return Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? kBlackish
                            : kBlackish.withOpacity(0.2)),
                  );
                }).toList(),
              ),
            )
          ],
        );
      },
    );
  }
}
