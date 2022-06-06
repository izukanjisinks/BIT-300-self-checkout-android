import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier{

  bool loading = true;

  List<Map<String,dynamic>> notifications = [];

  void gettingNotifications() async{

    notifications = [];

    loading = true;

    final snapshot = await FirebaseFirestore.instance.collection('announcements').get();

    for(int i = 0; i < snapshot.docs.length; i++) {
      notifications.add(snapshot.docs[i].data());
    }

    loading = false;

    notifyListeners();
  }

}