import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import 'package:self_checkout_application/ViewModel/history_view_model.dart';

class History extends StatefulWidget {


  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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

  List<Map<String,dynamic>> purchases = [];
  bool gettingHistory = true;

  @override
  void initState() {
    if(purchases.isEmpty) {
      Provider.of<HistoryViewModel>(context, listen: false).fetchHistory(
          context).then((value) {
       purchases = value;
       setState(() {
         gettingHistory = false;
       });
      });
    }else{
      setState(() {
        gettingHistory = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    purchases.sort((a,b) {
      DateTime aDate = DateTime.parse(a['products'][0]['id']);
      DateTime bDate = DateTime.parse(b['products'][0]['id']);
      return aDate.compareTo(bDate);
    });

    purchases = List.from(purchases.reversed);

    //purchases.sort((a,b) => a['products'][0]['id'](b)['products'][0]['id']);

    Provider.of<HistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('Purchases',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: gettingHistory ? Center(child: Container(height: 25.0,width: 25.0,child: CircularProgressIndicator(),),) : purchases.isEmpty ? Center(child: Text('purchases to show'),) : _purchases(context),
    );
  }

  Widget _purchases(BuildContext context){

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
                    purchases[index]['products'][0]['storeName'].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 8.0),
                  child: Text(
                    convertTime(purchases[index]['products'][0]['id']),
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
            _products(context,purchases[index]['products']),
            GestureDetector(
              onTap: () {
                setState(() {
                  purchases.removeAt(index);
                  Provider.of<HistoryViewModel>(context, listen: false).removePurchase(context, index);
                });
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
                  Text('Ref# ${purchases[index]['reference']}',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16.0),),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text( 'Total: K' + purchases[index]['total'].toString(),style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16.0),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    },itemCount: purchases.length,);
  }

  Widget _products(BuildContext context, List<dynamic> products){

    final historyProvider = Provider.of<UserModel>(context).userData!['history'];


    List<Widget> items = [];

    for (int i = 0; i < products.length; i++) {


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
                        child: FittedBox(child: Text('\K${products[i]['price']}')),
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
                              products[i]['title'],
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(
                            'Total \K${products[i]['price'] * products[i]['quantity']}'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${products[i]['quantity']} x',
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
