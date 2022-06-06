import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';

class UserAccountModel with ChangeNotifier{

  bool loading = true;

  void setLoading(bool loading){
    this.loading = loading;
    print('done loading');
    notifyListeners();
  }


  Map<String,dynamic> userAccountDetails(BuildContext context) {
  return Provider.of<UserModel>(context,listen: false).userData!;
}

void deleteAccount(BuildContext context){
  Provider.of<UserModel>(context,listen: false).deleteAccount(context);
}


void updateAccount(Map<String,dynamic> userMap,BuildContext context){
    print(userMap);
  Provider.of<UserModel>(context,listen: false).updateAccount(context);
}

void updateUi(){
    notifyListeners();
}


}