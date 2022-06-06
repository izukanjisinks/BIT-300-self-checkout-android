import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/cart_model.dart';
import '../Views/Widgets/dialogs.dart';
import 'package:hover_ussd/hover_ussd.dart';

// ignore: must_be_immutable
class Hover extends StatefulWidget {

  String reference;
  String amount;
  String userPhoneNumber;
  String sellerPhoneNumber;
  String carrier;

  Hover(this.sellerPhoneNumber,this.userPhoneNumber,this.amount, this.reference,this.carrier);

  @override
  _HoverState createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  final HoverUssd _hoverUssd = HoverUssd();

  Map<String, String> extras = {};

  //seems like stream builder executes not once, causing issuing with my order upload
  bool runOnce = true;

  @override
  void initState() {
    String phoneNumber = widget.sellerPhoneNumber.substring(3, 13).trim();
    extras = {
      "phoneNumber": phoneNumber,
      "amount": widget.amount,
     "reference": widget.reference
    };
    //
    super.initState();
  }

  void setActionId(BuildContext context,String userPhoneNumber,String sellerPhoneNumber){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.carrier == 'MTN mobile money'){
        actionId = "d89e8868";
        if(userPhoneNumber.startsWith('+26095')){
          Dialogs().incompatibleMobileMoneyDialog(context,'Note', 'Oops!Zamtel money not supported at the moment.');
        }else
          //check if trying to send money to airtel user, haven't added that action yet in hover
        if(sellerPhoneNumber.startsWith('+26097') || sellerPhoneNumber.startsWith('+26077')){
          Dialogs().incompatibleMobileMoneyDialog(context, 'Note', 'Can not send to Airtel money using MTN mobile money at the moment, only MTN to MTN and Airtel to Airtel transactions supported at the moment!');
        }else{
          initPayment();
        }
      }else if(widget.carrier == 'Airtel mobile money'){
        actionId = "d84201f6";
        if(userPhoneNumber.startsWith('+26095')){
          Dialogs().incompatibleMobileMoneyDialog(context,'Note', 'Oops!Zamtel money not supported at the moment.');
        }else
        if(sellerPhoneNumber.startsWith('+26096') ||sellerPhoneNumber.startsWith('+26076')){
          Dialogs().incompatibleMobileMoneyDialog(context, 'Note', 'Can not send to MTN mobile money using Airtel money at the moment, only MTN to MTN and Airtel to Airtel transactions supported at the moment!');
        }else{
          initPayment();
        }
      }
    });
  }

  void initPayment() {
    _hoverUssd.sendUssd(
      actionId: actionId!,
      extras: extras,

    );
  }

  //bool makePayment = true;
  String? actionId;

  @override
  Widget build(BuildContext _context) {

      setActionId(context, widget.userPhoneNumber, widget.sellerPhoneNumber);


    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              StreamBuilder<TransactionState>(
                stream: _hoverUssd.getUssdTransactionState,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == TransactionState.failed) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Dialogs().transactionFailed(_context);
                    });
                  }else if (snapshot.data == TransactionState.succesfull) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async{
                      if (runOnce) {
                        final cart = Provider.of<CartModel>(context,listen: false);
                        cart.purchaseItems(_context);
                        runOnce = false;
                      //Navigator.of(this.context).pop();
                        print('poping the context...............................................!');
                      }
                    });
                  }

                  return Text('');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
