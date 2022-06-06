import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/searchViewModel.dart';

class SearchModel with ChangeNotifier{


  List<Map<String,dynamic>> stores = [];

  bool loading = true;

  getStores(BuildContext context) async{
    final response = await FirebaseFirestore.instance
        .collection('webUsers')
        .get();
    for(int i = 0; i < response.docs.length; i++){
      stores.add(response.docs[i].data());
    }
    loading = false;
  }



}