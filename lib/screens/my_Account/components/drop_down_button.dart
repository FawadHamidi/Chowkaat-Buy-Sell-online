import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/constants.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDropDownButton extends StatefulWidget {
  // ValueChanged onChanged;
  String? city;

  MyDropDownButton({this.city});

  @override
  _MyDropDownButtonState createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3))),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: size.width - 20,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: kWhite,
          iconEnabledColor: kBlackish,
          value: widget.city,
          items: kCities.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  item,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: kBlackish, fontSize: 20),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              widget.city = value!;
              provider.cityForMyAccountDropDown = value;
              print(value);
            });
          },
        ),
      ),
    );
  }
}
