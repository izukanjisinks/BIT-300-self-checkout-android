import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import 'package:self_checkout_application/Views/Widgets/dialogs.dart';

import '../ViewModel/user_account_view_model.dart';

class UserAccount extends StatefulWidget {

  static const routeName = 'userAccount';

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final _form = GlobalKey<FormState>();

  void _saveForm(BuildContext context){
    final isValid = _form.currentState!.validate();
    if(isValid){
      _form.currentState!.save();
      final userModel = Provider.of<UserModel>(context,listen: false);
       userModel.userData = userDetails;
       userModel.updateAccount(context);
         print('is valid');
    }else{
      print('not valid');
    }
  }

  Map<String,dynamic> userDetails = {};

  void editUserDetails(BuildContext context){

  }

  @override
  void initState() {
    final userAccountModel = Provider.of<UserAccountModel>(context,listen: false);
    userDetails = {
      'userId': userAccountModel.userAccountDetails(context)['userId'],
      'firstName': userAccountModel.userAccountDetails(context)['firstName'],
      'lastName': userAccountModel.userAccountDetails(context)['lastName'],
      'address': userAccountModel.userAccountDetails(context)['address'],
      'phoneNumber': userAccountModel.userAccountDetails(context)['phoneNumber'],
      'history': userAccountModel.userAccountDetails(context)['history'],
      'savedCartList': userAccountModel.userAccountDetails(context)['savedCartList'],
      'showGuide' :userAccountModel.userAccountDetails(context)['showGuide']
    };
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

     final  userAccountModel = Provider.of<UserAccountModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(icon: Icon(Icons.delete_outline,color: Colors.red,),onPressed: (){
              Dialogs().deleteAccount(context);
            },),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Icon(Icons.person,size: 110.0,color: Colors.deepPurple.withOpacity(0.5),),
                //child: Image.asset('assets/icons/shopping-bags.png'),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'My Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0,color: Colors.deepPurple),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                    child: TextFormField(
                      initialValue: userAccountModel.userAccountDetails(context)['firstName'],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'First name',
                      ),
                      onSaved: (value) {
                        userDetails['firstName'] = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Enter your first name!';
                        if (value.length < 8)
                          return 'Please enter a valid name!';
                        else
                          return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                    child: TextFormField(
                      initialValue: userAccountModel.userAccountDetails(context)['lastName'],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Last name',
                      ),
                      onSaved: (value) {
                        userDetails['lastName'] = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Enter your last name!';
                        if (value.length < 8)
                          return 'Please enter a valid name!';
                        else
                          return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                    child: TextFormField(
                      initialValue: userAccountModel.userAccountDetails(context)['address'],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Address',
                          hintText: "h 22 cbu worker's compound",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onSaved: (value) {
                        userDetails['address'] = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter your address!';
                        if (value.length < 4)
                          return 'Please enter a valid address!';
                        else
                          return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                    child: TextFormField(
                      initialValue: userAccountModel.userAccountDetails(context)['phoneNumber'],
                      enabled: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Phone number',
                          errorStyle: TextStyle(color: Colors.red),
                          hintStyle: TextStyle(color: Colors.grey)),

                    ),
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepPurple.withOpacity(0.8)),
                            ),
                            onPressed: () {
                              _saveForm(context);
                            },
                            child: Text('Save Changes')))),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
