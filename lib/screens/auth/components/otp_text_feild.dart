import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  OtpTextField({required this.controller});
  TextEditingController controller = TextEditingController();
  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Expanded(
        child: TextFormField(
          textInputAction: TextInputAction.next,
          controller: widget.controller,
          maxLength: 1,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(counterText: '', border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
