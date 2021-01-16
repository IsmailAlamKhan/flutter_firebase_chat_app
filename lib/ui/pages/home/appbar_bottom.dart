import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/ui/widgets/inputs.dart';
import 'package:flutter/material.dart';

class AppBarBottom extends StatelessWidget {
  const AppBarBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: DefaultTextField(
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: DefaultIcon(
            Icons.search,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        label: 'Search',
      ),
    );
  }
}
