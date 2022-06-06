import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/user_view_model.dart';

import './phone_authentication.dart';
import 'Widgets/custom_bottom_sheet.dart';

class CreateAccount extends StatefulWidget {
  static const routeName = 'createAccount';

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _form = GlobalKey<FormState>();

  Map<String, dynamic> userDetails = {
    'firstName': null,
    'lastName': null,
    'address': null,
    'phoneNumber': null
  };

  bool gmail = false;

  void _saveForm(BuildContext context) {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      //signIn with google account
      if (gmail) {
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        userViewModel.googleAuth(
            userDetails['firstName'],
            userDetails['lastName'],
            userDetails['address'],
            userDetails['phoneNumber'],
            context);
      } else {
        //signIn with phone number
        Navigator.of(context)
            .pushNamed(PhoneAuth.routeName, arguments: userDetails);
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        userViewModel.phoneAuth(
            userDetails['firstName'],
            userDetails['lastName'],
            userDetails['address'],
            userDetails['phoneNumber'],
            context);
      }
    }
  }

  //displays dialog to confirm if user wants to exit the application
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    //willPopScope runs whenever back button is pressed
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            //form wraps around input fields and ensures fields are validated before data is saved
            child: Form(
              key: _form,
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Image.asset(
                    'assets/images/shopping-cart.png',
                  ),
                  //child: Image.asset('assets/icons/shopping-bags.png'),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Welcome To E-store',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'First name',
                        ),
                        onSaved: (value) {
                          userDetails['firstName'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter your first name!';
                          if (value.length < 3)
                            return 'Please enter a valid name!';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Last name',
                        ),
                        onSaved: (value) {
                          userDetails['lastName'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter your last name!';
                          if (value.length < 3)
                            return 'Please enter a valid name!';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Address',
                            hintText: "h 22 cbu worker's compound",
                            hintStyle: TextStyle(color: Colors.grey)),
                        onSaved: (value) {
                          userDetails['address'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter your address!';
                          if (value.length < 4)
                            return 'Please enter a valid address!';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Phone number',
                            prefix: Text(
                              '+260',
                              style: TextStyle(color: Colors.black),
                            ),
                            hintText: '969678807',
                            hintStyle: TextStyle(color: Colors.grey)),
                        onSaved: (value) {
                          userDetails['phoneNumber'] = '+260' + value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter your phone number!';
                          if (value.length > 9)
                            return 'Please enter a valid phone number!';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      bottomSheet(context);
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.deepPurple),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for phone authentication and google signIn option
  bottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CustomBottomSheet(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Text(
                        'Sign In With',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        gmail = false;
                        _saveForm(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.deepPurple,
                                ),
                                SizedBox(width: 5.0),
                                Text('Phone SignIn')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          gmail = true;
                          _saveForm(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 30.0,
                                  child: Image.asset(
                                    'assets/icons/google-logo.jpg',
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(width: 5.0),
                              Text('Google SignIn')
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
