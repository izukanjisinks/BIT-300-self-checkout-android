import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/cart_model.dart';
import 'package:self_checkout_application/ViewModel/history_view_model.dart';
import 'package:self_checkout_application/ViewModel/user_account_view_model.dart';
import 'package:self_checkout_application/ViewModel/user_view_model.dart';
import 'package:self_checkout_application/Views/create_account_page.dart';

import '../Views/Widgets/dialogs.dart';
import '../Views/home_page.dart';

class UserModel with ChangeNotifier {

  /*
  The userModel class is contains user data such as firstName, lastName etc
  this class also contains authentication logic and is used to fetch user
  data from the server
   */


  String? firstName;
  String? lastName;
  String? address;
  String? userId;
  String? phoneNumber;
  List<dynamic> history = [];
  List<dynamic> _savedCartList = [];
  bool showGuide = true;

  Map<String, dynamic>? userData;

  String smsCode = '';
  String verId = '';
  bool codeSent = false;
  bool loadingAccountInfo = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  int _seconds = 60;

  Timer _timer = Timer(Duration(), () {});

  String loggedIn = 'waiting';

  //document reference
  String? docId;

  int get seconds {
    return _seconds;
  }

  List<dynamic> get savedCartList {
    return _savedCartList;
  }

  void setSavedCartList(List<dynamic> list, BuildContext context) async {
    userData!['savedCartList'] = list;
    //update changes in firebase
    updateAccount(context);
  }

  void removePurchase(BuildContext context, int index) async {
    Dialogs().processing(context);
    history.removeAt(index);
    //update changes in firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update(userData!);
    Navigator.of(context).pop();
    Provider.of<HistoryViewModel>(context, listen: false).updateUI();
  }

  void setDetails(firstName, lastName, address, phoneNumber,
      List<dynamic> history, List<dynamic> cart) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.address = address;
    this.phoneNumber = phoneNumber;
    this.history = history;
    this._savedCartList = cart;
  }

  void setSmsCode(String value) {
    smsCode = value;
  }

  void start(BuildContext context) {
    if (_timer.isActive) {
      return;
    } else if (seconds == 60) {
      startTimer(context);
      phoneAuth(context);
      print('start');
    }
  }

  void startTimer(BuildContext context) {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_seconds > 0) {
          _seconds--;
        } else {
          timer.cancel();
          Provider.of<UserViewModel>(context, listen: false).codeResend(true);
        }
        Provider.of<UserViewModel>(context, listen: false)
            .updateSeconds(_seconds);
      },
    );
  }

  void phoneAuth(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        String errorMessage;

        if (e.code == 'invalid-phone-number') {
          errorMessage = 'The provided phone number is not valid.';
        } else {
          errorMessage = 'Could not sign you in, try again later!';
        }
        print('error messages');
        print(e.code);
        print(e.message);

        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        verId = verificationId;
        Provider.of<UserViewModel>(context, listen: false).codeArrived();
      },
      timeout: const Duration(seconds: 80),
      codeAutoRetrievalTimeout: (String verificationId) {
        ///To do
      },
    );
  }

  Future<void> signInWithOtp(BuildContext context) async {
    Dialogs().processing(context);
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      // Sign the user in (or link) with the credential
      final response = await auth.signInWithCredential(credential);

      userData = {
        'userId': response.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'phoneNumber': phoneNumber,
        'history': history,
        'savedCartList': _savedCartList,
        'showGuide': showGuide
      };

      final user = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .get();
      if (user.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .add(userData!)
            .catchError((e) {
          print(e);
        }).then((value) {
          Provider.of<UserAccountModel>(context, listen: false)
              .setLoading(false);
          //pop the dialog after checking whether the backend already contains this user or not
          docId = value.id;
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        });
      } else {
        print('welcome back!');
        setUserDetails(
            user.docs[0].data()['userId'],
            user.docs[0].data()['firstName'],
            user.docs[0].data()['lastName'],
            user.docs[0].data()['address'],
            user.docs[0].data()['phoneNumber'],
            user.docs[0].data()['showGuide'],
          user.docs[0].data()['history'],
          user.docs[0].data()['savedCartList'],
        );
        updateToken();
        Provider.of<UserAccountModel>(context, listen: false).setLoading(false);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Error",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
              ),
              content: Text(
                "An error occurred while signing you in,please make sure you have "
                    "entered the correct otp code that was sent to your phone. ",
                textAlign: TextAlign.center,
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  Future<void> googleSignIn(BuildContext context) async {

    try {
      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

      if (_googleSignInAccount!.id.isNotEmpty) Dialogs().processing(context);

      GoogleSignInAuthentication googleSignInAuthentication =
          await _googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      await auth.signInWithCredential(credential).catchError((onError) {
        print('an error occurred while signing in');
        Navigator.of(context).pop();
      });
      userExists(context);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      print(e);
      showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Error",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
              ),
              content: Text(
                "An error occurred while signing you in, try again.",
                textAlign: TextAlign.center,
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }


  handleAuth(BuildContext context) async {
    subscribe();
    //if currentUser is not null then the user
    //is signed in
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      loggedIn = 'true';
    } else {
      loggedIn = 'false';
    }
    if (loggedIn == 'true') {
      await getUserDetails(context);
      Navigator.pushNamed(context, HomePage.routeName);
    } else if (loggedIn == 'false') {
      Navigator.pushNamed(context, CreateAccount.routeName);
    }
  }

  //subscribes user to a topic to receive notifications
  void subscribe() async{
    await _messaging.subscribeToTopic('self-checkout-topic');
  }
  
  Future<void> getUserDetails(BuildContext context) async {
    loadingAccountInfo = true;
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get();
    docId = user.docs[0].id;
    //set details to local variable after fetching them
    //from firebase
    setUserDetails(
        user.docs[0].data()['userId'],
        user.docs[0].data()['firstName'],
        user.docs[0].data()['lastName'],
        user.docs[0].data()['address'],
        user.docs[0].data()['phoneNumber'],
        user.docs[0].data()['showGuide'],
        user.docs[0].data()['history'],
        user.docs[0].data()['savedCartList'],

    );
    loadingAccountInfo = false;

    Provider.of<CartModel>(context, listen: false).setSavedCartList(_savedCartList, context);

    Provider.of<UserAccountModel>(context, listen: false).setLoading(false);
  }

  Future<void> updateAccount(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update(userData!);
    // setUserDetails(userData!['userId'], userData!['firstName'], userData!['lastName'],
    //     userData!['address'], userData!['phoneNumber'], userData!['showGuide'],userData!['history'],userData!['savedCartList']);
    //Dialogs().changesSaved(context);
  }

  Future<bool> purchase(
      List<dynamic> list, BuildContext context, double total) async {
    bool successful = true;
    String datePurchased = DateTime.now().toIso8601String();
    //items in cart go to history list since they are now purchased
    for (int i = 0; i < list.length; i++) {
      list[i]['id'] = datePurchased;
    }
    userData!['history'].add({datePurchased: list, 'total': total});
    //saved cart list can now be empty
    userData!['savedCartList'] = [];

    await updateAccount(context)
        .catchError((onError) {
      successful = false;
      Dialogs().error(context);
    });
    Dialogs().purchaseSuccessful(context);
    return successful;
  }

  void setUserDetails(String _uid, String firstName, String lastName,
      String address, String phoneNumber, bool showGuide,List<dynamic> history, List<dynamic> savedCartList) {
    userData = {
      'userId': _uid,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
      'history': history,
      'savedCartList': savedCartList,
      'showGuide': showGuide
    };
  }

  void deleteAccount(BuildContext context) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
    try{
      //if user signed in with google
      _googleSignIn.disconnect();
    }catch(e){
      print(e);
    }
    auth.signOut().then((value) {
      Navigator.pushReplacementNamed(context, CreateAccount.routeName);
    });
  }

  void updateUi() {
    notifyListeners();
  }

  Future<void> userExists(BuildContext context) async {
    userData = {
      'userId': auth.currentUser!.uid,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
      'history': history,
      'savedCartList': _savedCartList,
      'showGuide': showGuide
    };
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    if (user.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .add(userData!)
          .catchError((e) {
        print(e);
      }).then((value) {
        Provider.of<UserAccountModel>(context, listen: false).setLoading(false);
        //pop the dialog after checking whether the backend already contains this user or not
        docId = value.id;
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      });
    } else {
      docId = user.docs[0].id;
      print('welcome back!');
      setUserDetails(
          user.docs[0].data()['userId'],
          user.docs[0].data()['firstName'],
          user.docs[0].data()['lastName'],
          user.docs[0].data()['address'],
          user.docs[0].data()['phoneNumber'],
          user.docs[0].data()['showGuide'],
        user.docs[0].data()['history'],
        user.docs[0].data()['savedCartList'],
      );
      updateToken();
      Provider.of<UserAccountModel>(context, listen: false).setLoading(false);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }
  /*
  the update token runs when the user logs into the app using a different authentication
  method than the one previously used, because firebase generates a different uuid for
  for a different authentication method, I update the previously used user token
  with the newly created so that I can always retrieve the old user data
   */

  Future<void> updateToken() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update(userData!)
        .then((value) {
      print('token update done!');
    }).catchError((onError) {
      print(onError);
    });
  }
}
