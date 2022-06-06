import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/notifications_provider.dart';

class Notifications extends StatefulWidget {

  static const routeName = 'notifications';

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String,dynamic>> nots = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.gettingNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    nots = notificationProvider.notifications;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.deepPurple,),onPressed: (){
          notificationProvider.loading = true;
          Navigator.of(context).pop();
        },),
      ),
      body: notificationProvider.loading ? Center(child: Container(height: 25.0,width: 25.0,child: CircularProgressIndicator(),),) : nots.isEmpty ? Center(child: Text('No notifications'),) : SingleChildScrollView(
        child:  _notification(context),
      ),
    );
  }

  Widget _notification(BuildContext context){

    List<Widget> _widgets = [];

    for(int i = 0; i < nots.length; i++){
      _widgets.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         nots[i]['imageUrl'] != '' ? Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius:  BorderRadius.circular(8.0),
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(
                        'assets/images/placeholder.jpg', fit: BoxFit.cover,),
                  imageUrl:  nots[i]['imageUrl']),
            ),
          ) : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: new BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(nots[i]['message'],style: TextStyle(color: Colors.grey),),
              ),
            ),
          )
        ],
      ));
    }

     return Column(children: _widgets,);
  }
}
