import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:appentus/code/constants.dart';
import 'package:appentus/code/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:appentus/code/database.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  PageType pageType = PageType.login;
  String name = '';
  String email = '';
  String password = '';
  int number = 0;
  String image = '';
  bool obscurity = true;

  pickImage() async {
    final picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final path = await getApplicationDocumentsDirectory();
      File imageFile = await File(path.path + pickedFile.path.split("/").last).writeAsBytes(await pickedFile.readAsBytes());
      setState(() {
        image = imageFile.path;
        print(image);
      });
    }
  }

  signup() async {
    var formState = _formKey.currentState;
    if (formState != null && !formState.validate()) return;
    if (image.isEmpty && pageType == PageType.signup) return openDialog('Error', 'Please choose an image to upload');
    User user = User(name: name, email: email, password: password, number: number, image: image);
    try {
      await UsersDatabase.instance.checkUser(email, password);
      openDialog('Error', 'User already exists with that email. Please use a different email address or login with your password.');
    } catch (e) {
      await UsersDatabase.instance.createUser(user);
      openDialog('Success', 'You have been signed up successfully! Please login with your credentials to continue.').then((value) {
        setState(() {
          pageType = PageType.login;
        });
      });
    }
  }

  login(UserInfo userInfo) async {
    var formState = _formKey.currentState;
    if (formState != null && !formState.validate()) return;
    try {
      User loggedInUser = await UsersDatabase.instance.checkUser(email, password);
      if (loggedInUser.id != null) {
        String token = loggedInUser.id.toString();
        userInfo.updateToken(token);
        userInfo.updateUser(loggedInUser);
        return;
      }
      openDialog('Error', 'The password was incorrect. Please try again.');
    } catch(e) {
      openDialog('Error', 'A user with the given email address does not exist. Please try again.');
    }
  }

  // readAll() async {
  //   final List<User> result = await UsersDatabase.instance.readAll();
  //   print(result);
  //   print(json.decode(json.encode(result.first)));
  // }

  Future openDialog(String title, String text) async {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Okay'))],
    );
    await showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    bool isSignupScreen = pageType == PageType.signup;

    textFields() => Column(
          children: [
            isSignupScreen
                ? TextFormField(
                    decoration: inputDecoration('Name'),
                    onChanged: (value) => name = value,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value == null || value.isEmpty) ? 'This field cannot be blank' : null,
                  )
                : SizedBox.shrink(),
            TextFormField(
              decoration: inputDecoration('Email Address'),
              onChanged: (value) => email = value,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.isEmpty) ? 'This field cannot be blank' : null,
            ),
            TextFormField(
              decoration: inputDecoration('Password').copyWith(suffixIcon: IconButton(
                icon: Icon(obscurity ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscurity = !obscurity;
                  });
                },
              )),
              obscureText: obscurity,
              onChanged: (value) => password = value,
              textInputAction: isSignupScreen ? TextInputAction.next : TextInputAction.done,
              validator: (value) => (value == null || value.length < 8) ? 'The password should at least be 8 characters long' : null,
            ),
            isSignupScreen
                ? TextFormField(
                    decoration: inputDecoration('Phone Number'),
                    onChanged: (value) => number = int.parse(value),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    validator: (value) => (value == null || value.length != 10) ? 'Please enter a valid phone number' : null,
                  )
                : SizedBox.shrink(),
          ],
        );

    imagePickerWidget() => isSignupScreen
        ? Column(
            children: [
              ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  child: image.isNotEmpty
                      ? Image.file(
                          File(image),
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 100,
                          color: appColor[200],
                        ),
                ),
              ),
              OutlinedButton(onPressed: pickImage, child: Text(image.isEmpty ? 'Choose Image' : 'Choose New Image'))
            ],
          )
        : SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        "Appentus Practical Task",
                        style: appNameStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: textFields(),
                ),
                imagePickerWidget(),
                ElevatedButton(
                    onPressed: () => isSignupScreen ? signup() : login(userInfo), child: Text(isSignupScreen ? 'Signup' : 'Login')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSignupScreen ? pageType = PageType.login : pageType = PageType.signup;
                      });
                    },
                    child: Text(isSignupScreen ? 'Have an account? Go to Login' : 'Click here to signup'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum PageType { signup, login }
