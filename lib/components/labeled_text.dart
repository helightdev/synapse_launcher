import 'package:flutter/material.dart';

import '../main.dart';

class LabeledText extends StatelessWidget {

  String label;
  String text;

  LabeledText(this.label, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: l1,),
          Text(text, style: b1,)
        ],
      ),
    );
  }
}
