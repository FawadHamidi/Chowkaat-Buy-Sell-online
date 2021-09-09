import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';

Widget searchContainer(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: kWhite,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, 'searchScreen');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              width: size.width - 20,
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: kBlackish,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'جستجو برای موتر, موبایل وغیره...',
                    style: TextStyle(
                        color: kBlackish.withOpacity(0.5), fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
