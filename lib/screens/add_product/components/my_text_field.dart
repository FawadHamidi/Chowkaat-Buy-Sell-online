import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField(
      {Key? key,
      this.title,
      required this.maxLines,
      this.isEnabled = true,
      this.hintText = '',
      this.height,
      this.maxLength,
      this.textInputType,
      this.controller})
      : super(key: key);
  double? height;
  final String? title;
  int? maxLength;
  var maxLines;
  final String hintText;
  bool isEnabled;
  TextInputType? textInputType;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              title ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
        Container(
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: kBlackish)),
            child: TextField(
              maxLength: maxLength,
              textInputAction: TextInputAction.next,
              enabled: isEnabled,
              controller: controller,
              style: TextStyle(fontSize: 16),
              keyboardType: textInputType,
              maxLines: maxLines,
              decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
            )),
      ],
    );
  }
}
