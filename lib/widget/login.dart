import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../backend/Util.dart';

/// Login Screen that manages login/signup flow.
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(_LoginFormController());
    Get.put(_LoginBackgroundController());
    return Material(
      // Use stack to position the login form over the background image.

      child: Stack(
        children: <Widget>[
          // Background
          _LoginBackground(),
          // Login/Signup Selection screen.
          const Center(child: LoginSelectionWidget()),

        ],

      ),
    );
  }
}

// Login Background widget with accelerometer sensor movement.
class _LoginBackground extends StatelessWidget {
  final _LoginBackgroundController c = Get.find<_LoginBackgroundController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Positioned(
          // Image that reacts with gyroscope to move left/right.
          top: 0,
          left: c.xPosition.value < 0 ? c.xPosition.value : 0,
          right: c.xPosition.value > 0 ? -c.xPosition.value : 0,
          bottom: 0,
          child: Image.asset('assets/image/background/starfall.gif',
            height: double.infinity,
            fit: BoxFit.fitHeight,
          ),
        ),
    );
  }
}

class _LoginBackgroundController extends GetxController {
  RxDouble xPosition = 0.0.obs;
  // Gyro-sensitive motion background
  // https://blog.joshsoftware.com/2020/12/12/flutter-interactive-motion-backgrounds/
  final double _backgroundShakeSensitivity = 0.8;
  final double _backgroundShakeLimit = 50;
  // Constructor that subscribes to accelerometer events.
  _LoginBackgroundController() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      var acc = event.x * _backgroundShakeSensitivity;
      xPosition.value +=
      (xPosition.value + acc).abs() <= _backgroundShakeLimit
          ? acc
          : 0.0;
    });
  }
}

/// Login/signup Selection container.

class LoginSelectionWidget extends StatelessWidget {
  const LoginSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(_LoginSelectionController());
    return Obx(() =>
      controller.isLoginSelected.value ? _LoginForm() : const SignupForm(),
    );
  }
}

class _LoginSelectionController extends GetxController {
  final RxBool isLoginSelected = true.obs;

}

class _LoginForm extends GetView<_LoginFormController> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // Login form that receives password, email and login button.
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Login" Text
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  // YUniverse Light.
                  fontFamily: 'YUniverse',
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            // Email text field.
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 5.0, 35.0, 15.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: const TextStyle(fontSize: 20, color: Colors.white),
                controller: controller.emailController,
                validator: controller.emailValidator,
              ),
            ),
            // Password text field.
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 5.0, 35.0, 15.0),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: const TextStyle(fontSize: 20, color: Colors.white),
                controller: controller.passwordController,
                validator: controller.passwordValidator,
              ),
            ),
            // Login button.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(180, 35)
              ),
              onPressed: () {
                controller.login();
              },
              child: const Text('Login'),
            ),
            // "Not a member? <a>sign up<a> text that change states to signup form.
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      // YUniverse Light.
                      fontFamily: 'YUniverse',
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  TextButton(
                    onPressed: () {
                      _LoginSelectionController loginController = Get.find();
                      loginController.isLoginSelected.value = false;
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        // YUniverse Light.
                        fontFamily: 'YUniverse',
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginFormController extends GetxController {
  // Login form key.
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  // Controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Validators
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Login
  void login() {
    if (loginFormKey.currentState!.validate()) {
      developer.log("Login button clicked, "
          "id: ${emailController.text}, "
          "password: ${passwordController.text}");
      // Login logic
      Dio().post('${Util.env('SERVER_URL')}/login',
          data: {
            'email': emailController.text,
            'password': passwordController.text,
          }).then((response) {
        if (response.statusCode == 200) {
          // Save token sent by server to database and navigate to MainScreen.
          Get.offAllNamed('/main');
        }
      });
    }
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('SignupForm'),
    );
  }
}
