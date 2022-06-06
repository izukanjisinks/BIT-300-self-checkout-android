import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import 'package:self_checkout_application/ViewModel/history_view_model.dart';

class History extends StatelessWidget {


  Map<String,dynamic>? map;



  String convertTime(String dateTime){
    DateTime _dateTime = DateTime.parse(dateTime);
    String timePurchased;
    String date = _dateTime.day.toString() + '/' + _dateTime.month.toString() + '/' + _dateTime.year.toString();
    if(_dateTime.minute < 10)
     timePurchased = _dateTime.hour.toString() + ':' + '0' + _dateTime.minute.toString();
    else
      timePurchased = _dateTime.hour.toString() + ':'  + _dateTime.minute.toString();

  String timePurchase = date + ' ' + timePurchased;

  return timePurchase;

  }

  @override
  Widget build(BuildContext context) {

    Provider.of<HistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('History',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: _purchases(context),
    );
  }


  Widget _purchases(BuildContext context){

    final historyProvider = Provider.of<UserModel>(context).userData!['history'];

    //historyProvider[index].values.toList()[1]

    print(historyProvider[0].values.toList()[1]);

    return ListView.builder(itemBuilder: (BuildContext context, int index){
       return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 8.0),
                  child: Text(
                    historyProvider[0].values.toList()[1][0]['storeName'].toString().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 8.0),
                  child: Text(
                    convertTime(historyProvider[index].keys.toList()[1]),
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0,),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            _products(context,index),
            GestureDetector(
              onTap: () {
               Provider.of<HistoryViewModel>(context, listen: false).removePurchase(context, index);
              },
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        'Remove',
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text('Total:',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16.0),),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text( 'K' + historyProvider[index]['total'].toString(),style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16.0),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    },itemCount: historyProvider.length,);
  }


  Widget _products(BuildContext context, int index){

    final historyProvider = Provider.of<UserModel>(context).userData!['history'];


    List<Widget> items = [];

    for (int i = 0; i < historyProvider[index].values.toList()[1].length; i++) {


      Widget item = Card(
          elevation: 0.0,
          margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FittedBox(child: Text('\K${historyProvider[index].values.toList()[1][i]['price']}')),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 120.0,
                            child: Text(
                              historyProvider[index].values.toList()[1][i]['title'],
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(
                            'Total \K${historyProvider[index].values.toList()[1][i]['price'] * historyProvider[index].values.toList()[1][i]['quantity']}'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${historyProvider[index].values.toList()[1][i]['quantity']} x',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
      items.add(item);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

}
