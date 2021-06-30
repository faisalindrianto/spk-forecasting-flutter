import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar({String title}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(56),
    child: AppBar(
      shadowColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      title: Text(
        title ?? "Sajiwo Lestari",
        style: TextStyle(
          color: Colors.green
        ),
      ),
    ),
  );
}