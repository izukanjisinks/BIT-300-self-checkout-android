import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../Model/get_product_model.dart';

class GetProductViewModel with ChangeNotifier{

  Map<String,dynamic> product = {};


  void getBarCode(Map<String,dynamic> arguments, BuildContext context){

    final getProductModel = Provider.of<GetProductModel>(context,listen: false);

    getProductModel.getProduct(arguments, context);

  }

  void updateUI(Map<String,dynamic> _product){
    product = _product;
    notifyListeners();
  }


}