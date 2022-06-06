import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import 'package:self_checkout_application/ViewModel/searchViewModel.dart';

import 'Widgets/dialogs.dart';

class Welcome extends StatefulWidget {

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool checkAuth = true;


  void auth(BuildContext context) async{
    final userModel = Provider.of<UserModel>(context,listen: false);
    await userModel.handleAuth(context);
    Provider.of<SearchViewModel>(context,listen: false).getStores(context);
  }


  StreamSubscription? subscription;
  bool popDialog = false;


  @override
  void initState() {
    // TODO: implement initState
    subscription = Connectivity().onConnectivityChanged.listen((event) => showConnectivitySnackBar(event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_){
      if(checkAuth)
       auth(context);
       checkAuth = false;
    });



    return Scaffold(
      body: Center(child: Container(height: 20.0,width: 20.0,child: CircularProgressIndicator(),),),
    );
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    print('what is going on here!');
    if(!hasInternet){
      print('no internet');
      Dialogs().noInternetConnectivity(context);
      popDialog = true;
    }
    else if(popDialog){
      print('aha internet');
      Navigator.of(context).pop();
      popDialog = false;
    }
  }


}
