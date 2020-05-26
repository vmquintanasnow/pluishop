import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
      ),
      dashColor: Colors.grey,
      blankLength: 4.0,
      strokeWidth: 0.4,
    );
  }
}
