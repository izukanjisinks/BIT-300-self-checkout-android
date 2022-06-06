import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/searchModel.dart';

class SearchViewModel with ChangeNotifier{

  List<Map<String,dynamic>> stores = [];

  void getStores(BuildContext context){
    Provider.of<SearchModel>(context,listen: false).getStores(context);
  }

   setStores(BuildContext context){
   stores = Provider.of<SearchModel>(context,listen: false).stores;
  }

}