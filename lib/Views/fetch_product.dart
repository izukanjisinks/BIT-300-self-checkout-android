import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/ViewModel/cart_view_model.dart';
import 'package:self_checkout_application/ViewModel/get_product_vew_model.dart';
import './scan_product_page.dart';
import './Widgets/product_card.dart';
import './Widgets/badge.dart';
import '../Views/shopping_cart_page.dart';

class FetchProduct extends StatefulWidget {

  static const routeName = 'FetchProduct';

  @override
  _FetchProductState createState() => _FetchProductState();
}

class _FetchProductState extends State<FetchProduct> {

  bool _fetch = true;
  bool _loadingProduct = true;

  Map<String,dynamic> product = {};

  void fetchProduct(BuildContext context, Map<String,dynamic> arguments) async{

    final getProductViewModel = Provider.of<GetProductViewModel>(context, listen: false);

    getProductViewModel.getBarCode(arguments, context).then((value) {
      setState(() {
        _loadingProduct = false;
        product = value;
      });
    });

  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Map<String,dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
      fetchProduct(context, arguments);
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    if(_fetch)
     // fetchProduct(context, arguments);
    _fetch = false;

    //Map<String,dynamic> product = Provider.of<GetProductViewModel>(context, listen: true).product;

    print(product);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepPurple,onPressed: (){
          Navigator.of(context).pushReplacementNamed(ScanPage.routeName,arguments: arguments['storeName']);
        },),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text( product.isEmpty ? '' : product['title'],style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left:9.0,right: 9.0,top: 8.0,bottom: 8.0),
            child: Consumer<CartViewModel>(
              builder: (_, cartData, ch) => Badge(
                textColor: Colors.white,
                child: ch!,
                value: cartData.cartNumItems.toString(),
                color: Colors.red,
              ),
              //this is a direct child of the consumer class, it will not rebuild
              //only item count text will rebuild
              //consumer helps to focus on specific widgets that should rebuild
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.deepPurple,
                  size: 18.0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCart(true)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body:_loadingProduct ? Center(child: Container(height: 20.0,width: 20.0,child: CircularProgressIndicator(),),) : product.isEmpty ? Center(child: Text('Product not found!'),) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: ProductCard(product)),
            ),
          ],
        ),
      ),
    );
  }
}
