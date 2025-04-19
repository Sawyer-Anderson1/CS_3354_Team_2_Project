import 'package:flutter/material.dart';

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: FractionallySizedBox(
          alignment: Alignment.topRight,
          widthFactor: 1.0, // Full width inside Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 70),
              Text(
                'Why Does It Matter?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 60,
                  height: 0.9,
                ),
              ),
              SizedBox(height: 83),
              Text(
                'Disasters strike unpredictably, and not everyone has the means or access to proper aid. '
                'Our platform bridges that gap by empowering everyday individuals to contribute directly to disaster relief efforts. '
                'By crowdsourcing help and resources, we increase the reach and speed of aid, ensuring more people are cared for when they need it most.',
                style: TextStyle(
                  fontSize: 21,
                  height: 1.7,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
