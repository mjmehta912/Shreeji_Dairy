import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';

class AppCard2 extends StatelessWidget {
  const AppCard2({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      color: kColorLightGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: kColorBlack,
        ),
      ),
      child: child,
    );
  }
}
