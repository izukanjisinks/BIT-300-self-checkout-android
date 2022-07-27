import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/cart_view_model.dart';
import 'package:self_checkout_application/ViewModel/get_product_vew_model.dart';

class GetProductModel with ChangeNotifier {
  Map<String, dynamic> product = {};
  Map<String, dynamic> _salesGraph = {};
  Map<String,dynamic> _seller = {};


  String _sellerDocId = '';
  List<String>  _productDocId = [];
  List<dynamic> _productsBought = [];

  Future<Map<String,dynamic>> getProduct(Map<String,dynamic> arguments, BuildContext context) async {
    
    final barCode = arguments['barCode'].toString();

    print(arguments);

    print(barCode);
    
    final response = await FirebaseFirestore.instance
        .collection('products')
    .where('storeName', isEqualTo: arguments['storeName'])
        .where('barCode', isEqualTo: barCode)
        .get()
        .catchError((e) {
      print(e);
    });

    print(response.docs);

    if(response.docs.isEmpty){
      //no product found
      product = {};
    }else {
      product = response.docs[0].data();
      product.putIfAbsent('docId', () => response.docs[0].id);
      _productDocId.add(response.docs[0].id);
    }
    if(product.isNotEmpty)
    getStoreDetails(product['storeName'], product['phoneNumber']);
    return product;
  }

  //we also get the store details to update them when we purchase a product
  void getStoreDetails(String storeName,String phoneNumber) async{
    final response = await FirebaseFirestore.instance
        .collection('webUsers')
        .where('storeName', isEqualTo: storeName)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .catchError((e) {
      print(e);
    });
    _sellerDocId = response.docs[0].id;
    _seller = response.docs[0].data();
    _salesGraph = response.docs[0].data()['salesGraph'];

  }

  void setProductsBought(List<dynamic> products,BuildContext context){
    _productsBought = products;
    updateGraph(context);
  }

  void updateGraph(BuildContext context) async{
    int year = DateTime.now().year;
    int month = DateTime.now().month;

    String graphKey = month.toString() + '-' + year.toString();

    _salesGraph.update(graphKey, (value) => value + 1.0);

    _seller['salesGraph'] = _salesGraph;

    var collection =  FirebaseFirestore.instance.collection('webUsers');
    collection.doc(_sellerDocId).update(_seller);
    updateProductCount(context);
  }

  void updateProductCount(BuildContext context) async{
    for(int i = 0; i < _productsBought.length; i++){
      var collection =  FirebaseFirestore.instance.collection('products');
      _productsBought[i]['saleCount'] = _productsBought[i]['saleCount'] + 1;
      if(_productsBought[i]['stockQuantity'] != 0) {
        print(_productsBought[i]['stockQuantity']);
        _productsBought[i]['stockQuantity'] = _productsBought[i]['stockQuantity'] - 1;
      }
      await collection.doc(_productsBought[i]['docId']).update(_productsBought[i]);
    }
  }


}
