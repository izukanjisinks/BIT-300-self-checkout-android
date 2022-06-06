import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/hover_ussd_model.dart';
import 'package:self_checkout_application/ViewModel/user_account_view_model.dart';

class Dialogs{

  Future<void> carrier(BuildContext context,String userPhoneNumber,String sellerPhoneNumber,String amount) {

    String carrier = 'MTN mobile money';

    Random random = Random();

   int _reference = random.nextInt(10000);

    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setState) {

            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Select an option',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('Cancel')),
                  // ignore: deprecated_member_use
                  FlatButton(onPressed: (){
                    //pop dialog
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Hover(sellerPhoneNumber,userPhoneNumber,amount,_reference.toString(),carrier)),
                    );
                  }, child: Text('Proceed'))
                ],
                content: Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25.0,bottom: 25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  carrier = 'MTN mobile money';
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    carrier == 'MTN mobile money'
                                        ? Icon(
                                      Icons.radio_button_checked,
                                      color: Colors.deepPurple,
                                    )
                                        : Icon(
                                      Icons.radio_button_unchecked_outlined,
                                      color: Colors.deepPurple,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'MTN money',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  carrier = 'Airtel mobile money';
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    carrier == 'Airtel mobile money'
                                        ? Icon(
                                      Icons.radio_button_checked,
                                      color: Colors.deepPurple,
                                    )
                                        : Icon(
                                      Icons.radio_button_unchecked_outlined,
                                      color: Colors.deepPurple,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Airtel money',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ));
          });
        });
  }

  cartEmpty(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Cart is empty',textAlign: TextAlign.center,style: TextStyle(color: Colors.deepPurple),),
            content: Text('Add items to cart before you can purchase anything!',textAlign: TextAlign.center,),
            actions: [
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop();
              }, child: Text('Ok'))
            ],
          );
        });
  }

  incompatibleMobileMoneyDialog(BuildContext context,String title,String body) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title,textAlign: TextAlign.center,style: TextStyle(color: Colors.deepPurple),),
            content: Text(body,textAlign: TextAlign.center,),
            actions: [
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              }, child: Text('Ok'))
            ],
          );
        });
  }
  Future<bool?> noWifi(BuildContext context) async{
    return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Make sure you are connected to wifi and try again!',
              textAlign: TextAlign.center,
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  noInternetConnectivity(BuildContext context) async{
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Connection Lost!',
              style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Make sure you are connected to the internet continue!',
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  Future<bool?> transactionFailed(BuildContext context) async{
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Failed',
              style: TextStyle(color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Transaction failed, try again later',
              textAlign: TextAlign.center,
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  processing(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 20.0,width:20.0,child: CircularProgressIndicator(),),
              ],
            ),
          );
        });
  }


  deleteAccount(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Are you sure you want to delete your account?',textAlign: TextAlign.center,),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('delete',style: TextStyle(color: Colors.red),),
                onPressed: (){
                  Navigator.of(ctx).pop();
                  Provider.of<UserAccountModel>(context,listen: false).deleteAccount(context);
                  processing(context);
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('cancel',style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  changesSaved(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Done',textAlign: TextAlign.center,),
            content: Text('Changes saved!',textAlign: TextAlign.center,),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('ok',style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  purchaseSuccessful(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Done',textAlign: TextAlign.center,),
            content: Text('Thank you for shopping with us!',textAlign: TextAlign.center,),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('ok',style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  error(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Error',textAlign: TextAlign.center,),
            content: Text('An error occurred while carrying out the operation',textAlign: TextAlign.center,),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('ok',style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }




}