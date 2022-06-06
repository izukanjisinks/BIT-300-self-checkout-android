import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:self_checkout_application/Model/cart_model.dart';
import 'package:self_checkout_application/ViewModel/cart_view_model.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {

  Map<String,dynamic> product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    print(product);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height:
                      MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.85,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/placeholder.jpg',
                        fit: BoxFit.cover,
                      ),
                      //i is the individual map in the list, we can access the value of the map
                      //in this way, at least in the carousel slider
                      imageUrl: product['imageUrl']),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset:
                      Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                           'K ' + product['price'].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9.0),
                        topRight: Radius.circular(9.0),
                      ),
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 12.0),
          child: Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0,right: 100.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(product['description'],textAlign: TextAlign.justify,style: TextStyle(color: Colors.black45),),
        ),
        SizedBox(height: 18.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 12.0),
          child: GestureDetector(
            onTap: (){
              final item = ItemModel(id: DateTime.now().toIso8601String(),title: product['title'],price: double.parse(product['price'].toString()),quantity: 1,sellerPhoneNumber: product['phoneNumber'],storeName:product['storeName'],saleCount: product['saleCount'],docId: product['docId'] );
              if(CartViewModel().addCartItem(item, context)){
                ScaffoldMessenger.of(context).showSnackBar(_alreadyInCart);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(_addedToCart);
              }
            },
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,color: Colors.deepPurple,),
                  SizedBox(width: 5.0,),
                  Text('Add to cart')
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  final _addedToCart = SnackBar(
    backgroundColor: Colors.deepPurple,
    content: const Text('Added to cart',style: TextStyle(),),
    action: SnackBarAction(
      label: '',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  final _alreadyInCart = SnackBar(
    backgroundColor: Colors.deepPurple,
    content: const Text('Product already in cart',style: TextStyle(),),
    action: SnackBarAction(
      label: '',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
