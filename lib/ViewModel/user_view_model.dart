import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import '../Model/user_model.dart';

class UserViewModel with ChangeNotifier{

  bool codeSent = false;
  bool resendCode = false;

  int _seconds = 0;

  void phoneAuth(String firstName,String lastName,String address,String phoneNumber,BuildContext context){
    Provider.of<UserModel>(context,listen: false).setDetails(firstName,lastName,address,phoneNumber,[]);
    Provider.of<UserModel>(context,listen: false).start(context);
  }

  void googleAuth(String firstName,String lastName,String address,String phoneNumber,BuildContext context){
    Provider.of<UserModel>(context,listen: false).setDetails(firstName,lastName,address,phoneNumber,[]);
    Provider.of<UserModel>(context,listen: false).googleSignIn(context);
  }

  void setSms(String sms, BuildContext context){
    final authProvider = Provider.of<UserModel>(context,listen: false);
    authProvider.setSmsCode(sms);
  }

  void signIn(BuildContext context){
    final userModel = Provider.of<UserModel>(context,listen: false);
    userModel.signInWithOtp(context);
  }

  void codeArrived(){
    codeSent = true;
    notifyListeners();
  }

  void codeResend(bool value){
    resendCode = value;
    notifyListeners();
  }

  int get seconds {
    return _seconds;
  }

  void updateSeconds(int _seconds){
    this._seconds = _seconds;
    notifyListeners();
  }
}