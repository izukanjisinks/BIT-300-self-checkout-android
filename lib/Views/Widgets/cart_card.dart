import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:self_checkout_application/ViewModel/cart_view_model.dart';


// ignore: must_be_immutable
class CartCard extends StatelessWidget {

  List<dynamic> cartItems = [];


  @override
  Widget build(BuildContext context){

    final cartData =  Provider.of<CartViewModel>(context);


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0,top: 8.0),
              child: Text(
                cartData.cartListItems(context)[0]['storeName'].toString().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            items(context),

          ],
        ),
      ),
    );
  }

  Column items(BuildContext context) {
    final cartData = Provider.of<CartViewModel>(context, listen: false);

    cartItems = cartData.cartListItems(context);

    List<Widget> list = [];
    for (int i = 0; i < cartItems.length; i++) {

      Widget item = Card(
          elevation: 0.0,
          margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(child: Text('\K${cartItems[i]['price']}')),
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
                          cartItems[i]['title'],
                          overflow: TextOverflow.ellipsis,
                        )),
                    Text(
                        'Total \K${cartItems[i]['price'] * cartItems[i]['quantity']}'),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${cartItems[i]['quantity']} x',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                            child: IconButton(
                                onPressed: () {
                                  cartData.increaseQuantity(context, cartItems[i]['id']);
                                },
                                icon: Icon(Icons.add, color: Colors.green))),
                        FittedBox(
                            child: IconButton(
                                onPressed: () {
                                  if (cartItems[i]['quantity'] > 1) {
                                    cartData.decreaseQuantity(context, cartItems[i]['id']);
                                  } else if (cartItems[i]['quantity'] == 1) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text(
                                              'Do you want to remove this item?'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                            ),
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                               cartData.removeFromCart(cartItems[i]['id'], context);
                                               Navigator.of(ctx).pop();
                                              },
                                            ),
                                          ],
                                        ));
                                  }
                                },
                                icon: Icon(Icons.remove, color: Colors.red))),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ));
      list.add(item);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
