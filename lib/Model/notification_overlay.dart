import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Views/notifications_screen.dart';

class NotificationOverlay{
  late final FirebaseMessaging _messaging;

  String? title;
  String? body;


  //register notification
  void registerNotification(BuildContext context) async {
    _messaging = FirebaseMessaging.instance;

    NotificationSettings notificationSettings =
    await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {

      //normal notification
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
       title = event.notification!.title;
       body = event.notification!.body;

        if (title != null && body != null) {

          showOverlayNotification((BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, Notifications.routeName);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height:  MediaQuery.of(context).size.width * 0.22,
                    child: Card(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(height: 35.0,width: 35.0,child: Image.asset('assets/images/shopping-cart.png',fit: BoxFit.cover)),
                          SizedBox(width: 8.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: MediaQuery.of(context).size.width * 0.7,child: Text(title!,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),softWrap: true,overflow: TextOverflow.fade,)),
                              SizedBox(height: 2.0,),
                              Container(width: MediaQuery.of(context).size.width * 0.7,child: Text(body!,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),)),
                            ],
                          ),
                        ],
                      ),
                    ),elevation: 0.0)
                ),
              ),
            );
          });
        }
      });
      //when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
        print(event);
       title = event.notification!.title;
       body = event.notification!.body;
      });

    }else{
      print('permission denied!');
    }
  }
}