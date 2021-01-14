import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.shade300,
                        spreadRadius: -10,
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF81B7F0).withOpacity(.8),
                        Colors.white,
                      ],
                      end: Alignment(2.0, 0.0),
                    ),
                    shape: BoxShape.circle,
                  ),
                  width: 150,
                  height: 150,
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
