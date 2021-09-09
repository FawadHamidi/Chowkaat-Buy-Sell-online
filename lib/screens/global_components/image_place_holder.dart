import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyImagePlaceHolder extends StatefulWidget {
  String? imageLink;
  double? height;
  double? width;

  MyImagePlaceHolder({this.imageLink, this.height, this.width});

  @override
  _MyImagePlaceHolderState createState() => _MyImagePlaceHolderState();
}

class _MyImagePlaceHolderState extends State<MyImagePlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageLink ?? '',
      imageBuilder: (context, imageProvider) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )),
        );
      },
      placeholder: (context, url) => Container(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/noImage.png'),
          ),
        ),
      ),
    );
  }
}
