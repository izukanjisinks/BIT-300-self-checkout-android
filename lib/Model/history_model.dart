import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/user_model.dart';
import '../ViewModel/history_view_model.dart';
import '../Views/Widgets/dialogs.dart';

class HistoryModel with ChangeNotifier{

  List<String> docIds = [];

  Future<List<Map<String, dynamic>>> getHistory(BuildContext context) async{
    List<Map<String,dynamic>> history = [];
    final docId = Provider.of<UserModel>(context,listen: false).userData!['phoneNumber'];
    final snapshots = await FirebaseFirestore.instance.collection('purchases').where(docId).get();

    for(int i = 0; i < snapshots.docs.length; i++){
      history.add(snapshots.docs[i].data());
      docIds.add(snapshots.docs[i].id);
    }
    return history;

  }

  void removePurchase(BuildContext context, int index) async {

    //Dialogs().processing(context);
    //update changes in firebase
    await FirebaseFirestore.instance
        .collection('purchases')
        .doc(docIds[index])
        .delete();
    docIds.removeAt(index);
   // Navigator.of(context).pop();
  }


}