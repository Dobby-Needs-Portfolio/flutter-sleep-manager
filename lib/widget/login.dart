import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Login Screen that manages login/signup flow.
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use stack to position the login form over the background image.

      child: Stack(
        children: const <Widget>[
          LoginBackground(),

        ],

      ),

    );
  }
}

class LoginBackground extends StatefulWidget {
  const LoginBackground({Key? key}) : super(key: key);

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> {
  // Gyro-sensitive motion background
  // https://blog.joshsoftware.com/2020/12/12/flutter-interactive-motion-backgrounds/
  final int backgroundShakeSensitivity = 1;
  double xPosition = 0;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    _accelerometerSubscription =
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        xPosition +=
          (xPosition + event.x * backgroundShakeSensitivity).abs() <= 50 ?
          event.x * backgroundShakeSensitivity : 0;
        print(xPosition);
      });
    });
    super.initState();
  }
  
  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // Image that reacts with gyroscope to move left/right.
      // The image is positioned in the center of the screen.
      top: 0,
      left: xPosition > 0 ? -xPosition : 0,
      right: xPosition < 0 ? xPosition : 0,
      bottom: 0,
      child: Image.asset('assets/image/background/starfall.gif',
        height: double.infinity,
        fit: BoxFit.fitHeight,
      ),
    );

  }
}

