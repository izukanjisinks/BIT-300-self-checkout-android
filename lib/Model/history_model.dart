import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/user_model.dart';

class HistoryModel with ChangeNotifier{

  List<dynamic> getHistory(BuildContext context){
   return Provider.of<UserModel>(context,listen: false).history;
  }


}