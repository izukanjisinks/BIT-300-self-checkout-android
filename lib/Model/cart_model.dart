import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/get_product_model.dart';
import 'package:self_checkout_application/Model/user_model.dart';

import '../ViewModel/cart_view_model.dart';

class ItemModel{
  String id;
  String title;
  int quantity;
  double price;
  String sellerPhoneNumber;
  String storeName;
  String docId;
  int saleCount;

  ItemModel({required this.id, required this.title, required this.quantity, required this.price,required this.sellerPhoneNumber,required this.storeName,required this.docId,required this.saleCount});
}

class CartModel with ChangeNotifier{

  List<dynamic> cartList = [];

  void addItem(ItemModel item,BuildContext context){

    final cartViewModel = Provider.of<CartViewModel>(context,listen: false);

    Map<String,dynamic> _cartItem = {
      'id' : item.id,
      'storeName' : item.storeName,
      'title' : item.title,
      'quantity' : item.quantity,
      'price' : item.price,
      'phoneNumber' : item.sellerPhoneNumber,
      'docId' : item.docId,
      'saleCount' : item.saleCount
    };

    cartList.add(_cartItem);

    cartViewModel.setCartItems(cartList.length);

    Provider.of<UserModel>(context, listen: false).setSavedCartList(cartList, context);

    cartViewModel.updateUI();

  }

  bool findItem(String _name){
    bool exists = false;

    for(int i = 0; i < cartList.length; i++){
      if(cartList[i]['title'] == _name)
        exists = true;
    }
    return exists;
  }


  List<dynamic> cartItemsList(){
    return cartList;
  }

  void setSavedCartList(List<dynamic> list,BuildContext context){
    cartList = list;
    Provider.of<CartViewModel>(context,listen: false).updateUI();
  }

  void removeItem(var id, BuildContext context){
    for(int i = 0; i < cartList.length; i++){
      if(cartList[i]['id'] == id){
        cartList.removeAt(i);
      }
    }

    Provider.of<UserModel>(context, listen: false).setSavedCartList(cartList, context);
    final cartViewModel = Provider.of<CartViewModel>(context,listen: false);
    cartViewModel.setCartItems(cartList.length);
    cartViewModel.updateUI();

  }

  void increaseProductQuantity(BuildContext context, String productId){
    for(int i = 0; i < cartList.length; i++){
      if(cartList[i]['id'] == productId){
        cartList[i]['quantity'] += 1;
      }
    }
    cartTotal();
    Provider.of<UserModel>(context, listen: false).setSavedCartList(cartList, context);
    Provider.of<CartViewModel>(context,listen: false).updateUI();
  }

  void decreaseProductQuantity(BuildContext context, String productId){
    for(int i = 0; i < cartList.length; i++){
      if(cartList[i]['id'] == productId){
        //we do not want quantity to be less than 0
        if(cartList[i]['quantity'] > 1)
        cartList[i]['quantity'] -= 1;
      }
    }
    cartTotal();
    Provider.of<UserModel>(context, listen: false).setSavedCartList(cartList, context);
    Provider.of<CartViewModel>(context,listen: false).updateUI();
  }

  double cartTotal(){
    double _total = 0.0;
    for(int i = 0; i < cartList.length;i++){
      _total += (cartList[i]['price'] * cartList[i]['quantity']);
    }
    return _total;
  }

  void purchaseItems(BuildContext context) async{
   bool purchaseSuccessful = await Provider.of<UserModel>(context, listen: false).purchase(cartList,context,cartTotal());
   if(purchaseSuccessful) {
     Provider.of<GetProductModel>(context, listen: false).setProductsBought(cartList,context);
     Provider.of<CartViewModel>(context, listen: false).setCartItems(0);
     cartList = [];
   }
   Provider.of<CartViewModel>(context,listen: false).updateUI();
  }


}