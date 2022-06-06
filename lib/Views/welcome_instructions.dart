import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';

import '../ViewModel/user_account_view_model.dart';


// ignore: must_be_immutable
class WelcomeInstructions extends StatefulWidget {
  @override
  _WelcomeInstructionsState createState() => _WelcomeInstructionsState();
}

class _WelcomeInstructionsState extends State<WelcomeInstructions> {
  List<Slide> slides = [];

  @override
  void initState() {
    // TODO: implement initState
    //addSlides();
    super.initState();
  }

  void addSlides() {
    slides.add(
      new Slide(
        title: "Home Screen",
        description:
        "your home screen will look like this, you can search for a store or use the store's wifi to start scanning for products",
        pathImage: "assets/instructions/searchOrUseWifi.jpg",
        widthImage: MediaQuery.of(context).size.width * 0.7,
        heightImage: MediaQuery.of(context).size.height * 0.6,
        //foregroundImageFit: BoxFit.,
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "Navigation",
        description:
        "Use the bottom navigation to switch to the appropriate screen",
        pathImage: "assets/instructions/navBar.jpg",
        widthImage: MediaQuery.of(context).size.width * 0.7,
        heightImage: MediaQuery.of(context).size.height * 0.6,
        //foregroundImageFit: BoxFit.,
        backgroundColor: Color(0xff203152),
      ),
    );
  }
  @override
  void didChangeDependencies() {
    addSlides();
    super.didChangeDependencies();
  }

  void onDonePress() {
    // Do what you want
    print("End of slides");

   final user =  Provider.of<UserModel>(context,listen: false);

   //we do not want to show the guide next user starts the app
   user.userData!['showGuide'] = false;

    Provider.of<UserAccountModel>(context,listen: false).updateUi();

   FirebaseFirestore.instance
        .collection('users')
        .doc(user.docId)
        .update(user.userData!);

  }


  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      child: IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
      ),
    );
  }
}
