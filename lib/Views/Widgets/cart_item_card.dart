import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/cart_view_model.dart';


class CartItemCard extends StatelessWidget {

  Map<String, dynamic> product;
  CartItemCard(this.product);

  @override
  Widget build(BuildContext context) {

    final cartViewModel = Provider.of<CartViewModel>(context,listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15.0),
      child: Card(
        elevation: 2.5,
        color: Colors.white.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
          child: Row(
            children: [
              CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(child: Text('K' + product['price'].toString())),
                ),
              ),
              SizedBox(width: 8.0,),
              Text(product['title'],style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
              Text(' x' + product['quantity'].toString(),style: TextStyle(color: Colors.deepPurple)),
              Expanded(child: Container()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                IconButton(icon: Icon(Icons.add,color: Colors.green,),onPressed: (){
                  cartViewModel.increaseQuantity(context, product['id']);
                }),
                IconButton(icon: Icon(Icons.remove, color: Colors.red,),onPressed: (){
                  cartViewModel.decreaseQuantity(context, product['id']);
                }),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
