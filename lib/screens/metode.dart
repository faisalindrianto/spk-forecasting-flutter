import 'package:flutter/material.dart';
import 'package:spk/custom_widget.dart';

class MetodePage extends StatefulWidget {
  const MetodePage({ Key key }) : super(key: key);

  @override
  _MetodePageState createState() => _MetodePageState();
}

class _MetodePageState extends State<MetodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Metode"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/metode.jpeg",
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}