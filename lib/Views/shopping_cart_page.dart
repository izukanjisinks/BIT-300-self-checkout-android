import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/cart_view_model.dart';
import 'package:self_checkout_application/Views/Widgets/cart_card.dart';
import '../Model/user_model.dart';
import './Widgets/cart_item_card.dart';
import '../Model/cart_model.dart';
import './Widgets/dialogs.dart';

class ShoppingCart extends StatelessWidget {

  bool backButton;
  ShoppingCart(this.backButton);

  static const routeName = 'cart';

  @override
  Widget build(BuildContext context) {

    final _cartItemsList = Provider.of<CartViewModel>(context).cartListItems(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: backButton ? IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepPurple,onPressed: (){
         Navigator.of(context).pop();
        },) : Container(),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('My Cart',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(children: [
      _cartItemsList.isEmpty ? Expanded(child: Center(child: Text('No Items In Cart')) ) :  Expanded(
          child: SingleChildScrollView(
            child:   CartCard(),
          ),
        ),
//        Expanded(child: _cartItemsList.isEmpty ? Center(child: Text('No items in cart'),) : ListView.builder(itemBuilder: (BuildContext context, int index){
//          return CartItemCard(_cartItemsList[index]);
//        }, itemCount: _cartItemsList.length,)),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text('Total: K' + Provider.of<CartViewModel>(context,listen: false).total(context).toString(),style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18.0),),
              Expanded(child: Container()),
              // ignore: deprecated_member_use
              FlatButton(onPressed: (){
                if(_cartItemsList.isEmpty){
                  Dialogs().cartEmpty(context);
                }else {
                  final cartProvider = Provider.of<CartModel>(context, listen: false);
                  //cartProvider.purchaseItems(context);
                  final String userPhoneNumber = Provider.of<UserModel>(context, listen: false).userData!['phoneNumber'];
                  String sellerPhoneNumber = _cartItemsList.isEmpty ? '' : _cartItemsList[0]['phoneNumber'];
                  Dialogs().carrier(context, userPhoneNumber, sellerPhoneNumber, Provider.of<CartViewModel>(context, listen: false).total(context).toString());
                }
              }, child: Text('Check Out',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18.0),))
            ],
          ),
        )
      ],),
    );
  }
}
