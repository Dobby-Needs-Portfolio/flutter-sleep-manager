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
    Get.put(_SignupFormController());
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
      controller.isLoginSelected.value ? _LoginForm() : _SignupForm(),
    );
  }
}

class _LoginSelectionController extends GetxController {
  final RxBool isLoginSelected = false.obs;

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

class _SignupForm extends GetView<_SignupFormController> {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "Login" Text
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Sign up',
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
          // Username text field.
          Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 5.0, 35.0, 15.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: const TextStyle(fontSize: 20, color: Colors.white),
              controller: controller.usernameController,
              validator: controller.usernameValidator,
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
              controller.signup();
            },
            child: const Text('Sign up'),
          ),
          // "Already registered? <a>login<a> text that change states to signup form.
          Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Already registered?',
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
                    loginController.isLoginSelected.value = true;
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple,
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
    );
  }
}

class _SignupFormController extends GetxController {
  // Signup form key.
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  // Controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Validators
  String? usernameValidator(String? value) {
    // If value is empty
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    // If value has forbidden characters
    if (!RegExp("^[A-Za-z0-9._]+\$").hasMatch(value)) {
      return 'Only lowercase, uppercase, number, ._ is allowed';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    // If password is empty
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // If password have unauthorised characters
    if (!RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*])(?=.{8,})").hasMatch(value)) {
      return 'Only lowercase, uppercase, numbers and !@#\$%^& allowed';
    }
    // If password is less than 8 characters or more than 40 characters
    else if (value.length < 8 || value.length > 20) {
      return 'Password must be between 8 and 40 characters';
    }
    // If password does not contain at least one uppercase letter
    else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    // If password does not contain at least one lowercase letter
    else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    // If password does not contain at least one number
    else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    // If password does not contain at least one special character
    else if (!RegExp(r'[!@#\$%^&*]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Signup
  void signup() {
    if (signupFormKey.currentState!.validate()) {
      developer.log("Signup button clicked, "
          "username: ${usernameController.text}, "
          "email: ${emailController.text}, "
          "password: ${passwordController.text}");
      // Signup logic
      Dio().post('${Util.env('SERVER_URL')}/signup',
          data: {
            'username': usernameController.text,
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
