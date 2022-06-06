import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../Model/cart_model.dart';

class CartViewModel with ChangeNotifier{

  int cartNumItems = 0;


  bool addCartItem(ItemModel item,BuildContext context){

    bool _isInCart = false;

    //we first check if the product has already been added to the cart
    //if it is already in the cart we don't add it


    if(Provider.of<CartModel>(context, listen: false).findItem(item.title)){
      //product already added to cart
      _isInCart = true;
    }else{
      Provider.of<CartModel>(context, listen: false).addItem(item, context);
    }

    return _isInCart;
  }

  //sets the number of items in cart
  void setCartItems(int _cartNumItems){
    cartNumItems = _cartNumItems;
  }

  //updates the UI
  void updateUI(){
    notifyListeners();
  }

  void purchase(BuildContext context){
    Provider.of<CartModel>(context, listen: false).purchaseItems(context);
  }

  List<dynamic> cartListItems(BuildContext context){
    return Provider.of<CartModel>(context, listen: false).cartItemsList();
  }

  void increaseQuantity(BuildContext context,String productId){
    Provider.of<CartModel>(context, listen: false).increaseProductQuantity(context, productId);
  }

  void decreaseQuantity(BuildContext context,String productId){
    Provider.of<CartModel>(context, listen: false).decreaseProductQuantity(context, productId);
  }

  void removeFromCart(var id,BuildContext context){
    Provider.of<CartModel>(context, listen: false).removeItem(id,context);
  }

  double total(BuildContext context){
    return Provider.of<CartModel>(context, listen: false).cartTotal();
  }


}