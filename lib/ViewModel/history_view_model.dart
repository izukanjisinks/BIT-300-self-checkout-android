import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import '../Model/history_model.dart';

class HistoryViewModel with ChangeNotifier{

  List<dynamic> history = [];

  void setHistory(BuildContext context){
   history = Provider.of<HistoryModel>(context,listen: false).getHistory(context);
   //print(history);
   updateUI();
  }

  void updateUI(){
    notifyListeners();
  }

  void removePurchase(BuildContext context, int index){
    Provider.of<UserModel>(context,listen: false).removePurchase(context, index);
  }

}