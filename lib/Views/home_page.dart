import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:self_checkout_application/Model/wifi_model.dart';
import 'package:self_checkout_application/ViewModel/searchViewModel.dart';
import 'package:self_checkout_application/Views/history.dart';
import 'package:self_checkout_application/Views/hover_instructions.dart';
import 'package:self_checkout_application/Views/scan_product_page.dart';
import 'package:self_checkout_application/Views/user_account.dart';
import 'package:self_checkout_application/Views/welcome_instructions.dart';

import '../ViewModel/user_account_view_model.dart';
import '../Views/shopping_cart_page.dart';
import 'Widgets/dialogs.dart';
import 'notifications_screen.dart';

class HomePage extends StatefulWidget {

  static const routeName = 'homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;



  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              exit(0);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  List<Map<String, dynamic>> _stores = [];

  List<Map<String, dynamic>> _searchedList = [];

  String _currentStore = '';

  bool _searchStore = false;

  String? wifiName;

 // WifiInfoWrapper? _wifiObject;

  @override
  void initState() {
    super.initState();
  }


//  Future<void> initPlatformState() async {
//    WifiInfoWrapper? wifiObject;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      wifiObject = await WifiInfoPlugin.wifiDetails;
//    } on PlatformException {}
//    if (!mounted) return;
//
//    _wifiObject = wifiObject;
//
//    print(_wifiObject!.ssid);
//    print(_wifiObject!.bssId);
//    print(_wifiObject!.connectionType);
//    print(_wifiObject!.ipAddress);
//    print(_wifiObject!.networkId);
//
//  }


  void _getWifiName(BuildContext context) async{

//    if (await Permission.location.isDenied) {
//      Permission.location.request();
//    } else if (await Permission.location.isGranted)
//      NetworkInfo().getWifiName().then((value) => print(value));

    print('getting name');
    Dialogs().processing(context);
     final wifi = await Provider.of<WifiModel>(context,listen: false).getWifiName();

    final wifiModel = Provider.of<WifiModel>(context,listen: false);
    print('gotten name');
    Navigator.of(context).pop();
    if(wifiModel.error){
      //error dialog
     Dialogs().noWifi(context);
    }else if(wifiModel.wifiName == null){
      //error dialog
      Dialogs().noWifi(context);
    }else{
      setState(() {
        wifiName = wifiModel.wifiName;
        //wifi name becomes store name, we use this name to search db along with barcode
        _currentStore = wifiName!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final userAccountModel = Provider.of<UserAccountModel>(context);
    Provider.of<SearchViewModel>(context, listen: false).setStores(context);
    _stores = Provider.of<SearchViewModel>(context, listen: false).stores;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: userAccountModel.userAccountDetails(context)['showGuide'] ?
      WelcomeInstructions() : Scaffold(
        body: userAccountModel.loading
            ? Center(child: Container(
          height: 20.0, width: 20.0, child: CircularProgressIndicator(),)) :  currentScreen(_currentIndex, context),
        backgroundColor: Colors.white,
        bottomNavigationBar:  SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [

            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Cart screen
            SalomonBottomBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              title: Text("Cart"),
              selectedColor: Colors.pink,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.teal,
            ),

            /// History screen
            SalomonBottomBarItem(
              icon: Icon(Icons.history),
              title: Text("History"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget currentScreen(int index, BuildContext context) {
    Widget _screen = Container(color: Colors.white,);

    if (index == 0)
      _screen = _homePage(context);
    if (index == 1)
      _screen = ShoppingCart(false);
    if (index == 2)
      _screen = UserAccount();
    if (index == 3)
      _screen = History();

    return _screen;
  }

  Widget _homePage(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/grocery.jpg', fit: BoxFit.fitHeight, height: MediaQuery
            .of(context)
            .size
            .height,),
        Container(color: Colors.black.withOpacity(0.5), height: MediaQuery
            .of(context)
            .size
            .height),
        Positioned(left: 20.0,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            child: Image.asset('assets/images/shopping-cart.png')),
        Positioned(left: 20.0,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: Text('Welcome To E-Store', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0),)),
        Positioned(left: 20.0,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.45,
            child: Text('Scan products to add\nthem to your cart',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),)),
       _currentStore == '' ? Container() : Positioned(left: 20.0, top: MediaQuery
            .of(context)
            .size
            .height * 0.56, child: Row(
              children: [
                Center(
                child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.37,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.withOpacity(0.8)),
                        ),
                        onPressed: () {
                          print('the current store is ' + _currentStore);
                          Navigator.of(context).pushNamed(ScanPage.routeName,arguments: _currentStore);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: Colors.white,),
                            SizedBox(width: 10.0,),
                            Text('Start Scan'),
                          ],
                        )))),
                SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        _currentStore,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,fontWeight: FontWeight.bold),)
              ],
            )),
       _searchStore ? Positioned(left: 20.0, top: MediaQuery
            .of(context)
            .size
            .height * 0.15, child: Container(width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
          child: CupertinoSearchTextField(
            backgroundColor: Colors.white, onChanged: (value) {
            _searchedList = [];
            String searchQuery =  StringUtils.capitalize(value,allWords: false);
              _stores.forEach((element) {
                if(element['storeName'].toString().startsWith(searchQuery)){
                  setState(() {
                    _searchedList.add(element);
                  });
                }
              });
              if(value.isEmpty)
                setState(() {
                  _searchedList = [];
                });
          },),)) : Container(),
       _searchedList.isNotEmpty ? Positioned(left: 20.0, top: MediaQuery
            .of(context)
            .size
            .height * 0.22, child: _searchResult(context)) : Container(),
      _currentStore.isEmpty ?   Positioned(left: 20.0,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.62,
            child: Row(children: [
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.orange),
                          ),
                          onPressed: () {
                            setState(() {
                              _searchStore = true;
                            });
                              },
                          child: Text('Search store')))),
              SizedBox(width: 8.0,),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurple),
                          ),
                          onPressed: () {
                               _getWifiName(context);
                          },
                          child: Text('Use wifi')))),
            ],)) : Positioned(
              left: 20.0,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.65,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple),
                      ),
                      onPressed: () {
                        setState(() {
                                  _currentStore = '';
                                });
                              },
                      child: Text('Change store'))),
            ),

        Positioned(top: 25.0,right: 15.0,child: IconButton(icon: Icon(Icons.help,color: Colors.white),onPressed:(){
         Navigator.pushNamed(context, FAQS.routeName);
        })),
        Positioned(top: 25.0,right: 60.0,child: IconButton(icon: Icon(Icons.notifications_active_outlined,color: Colors.white),onPressed:(){
          Navigator.pushNamed(context, Notifications.routeName);
        }))

      ],),
    );
  }

  Widget _searchResult(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.8,
      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              setState(() {
                _currentStore = _searchedList[index]['storeName'];
                _searchedList = [];
              });
            },
            child: Container(
              color: Colors.transparent,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.08,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/shop.png',width: 25.0,),
                        SizedBox(width: 15.0,),
                        Text(_searchedList[index]['storeName'],style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(),
                  )
                ],
              ),
            ),
          ),
        );
      }, itemCount: _searchedList.length,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

}
