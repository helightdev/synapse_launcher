import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import '../main.dart';

class LabeledCheckbox extends StatelessWidget {
 
  String label;
  bool value;
  Function(bool) onChanged;


  LabeledCheckbox({this.label, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: l1,),
        Checkbox(
            value: value,
            onChanged: onChanged,
          fillColor: MaterialStateProperty.all("#16a085".toColor()),
        ),
      ],
    );
  }
}
