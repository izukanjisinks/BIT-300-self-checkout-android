import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../Model/get_product_model.dart';

class GetProductViewModel with ChangeNotifier{


  Future<Map<String,dynamic>> getBarCode(Map<String,dynamic> arguments, BuildContext context) async{

    final getProductModel = Provider.of<GetProductModel>(context,listen: false);

    return await getProductModel.getProduct(arguments, context);

  }


}