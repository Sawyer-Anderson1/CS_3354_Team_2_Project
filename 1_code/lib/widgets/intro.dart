import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
      child: Align(
        alignment: Alignment.topLeft, // Align content to the left
        child: FractionallySizedBox(
          alignment: Alignment.topLeft, // Align inside the FractionallySizedBox
          widthFactor: 1.0, // Set width to 50% of the screen width (left side of the center)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: <Widget>[
              SizedBox(height: 70), // Add space before the first text
              Text(
                'Crowdsourced Disaster Relief System',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 60,
                  height: 0.9,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'The purpose of our platform is to give users a chance to help out the community and to get help themselves.' 
                ' Our website offers key features like seeing the current resources in your area, making a request on any kind of '
                'situation like medical, shelter or food supplies. It also has a donation system where users can donate either money or '
                'resources that would help out many people in need. There is also an emergency alerts page where users can see what is '
                'happening and when they are happening so they stay alert and safe. ',
                style: TextStyle(
                  fontSize: 21,
                  height: 1.7,
                ),
                softWrap: true, // Allow wrapping of text
                overflow: TextOverflow.fade, // Avoid overflow issues
              ),
            ],
          ),
        ),
      ),
    );
  }
}





