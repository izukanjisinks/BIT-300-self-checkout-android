import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/user_view_model.dart';


class PhoneAuth extends StatefulWidget {
  static const routeName = '/SMSAuth';

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _form = GlobalKey<FormState>();
  String smsCode = '';

  void _saveForm() async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      final setCode = Provider.of<UserViewModel>(context, listen: false);
      setCode.setSms(smsCode,context);
      Provider.of<UserViewModel>(context, listen: false).signIn(context);
    }
  }

  @override
  void initState() {
    //final args = ModalRoute.of(context)!.settings.arguments as Map;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final userViewModel = Provider.of<UserViewModel>(context,listen: false);



    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeData.light().scaffoldBackgroundColor,
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepPurple,onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Image.asset('assets/images/shopping-cart.png'),
                //child: Image.asset('assets/icons/shopping-bags.png'),
              ),

              SizedBox(
                height: 17.0,
              ),
              Text(
                'Enter sms code',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 23.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                key: _form,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 2),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'sms code',
                        ),
                        onSaved: (value) {
                          smsCode = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Enter code sent to phone!';
                          if (value.length < 6)
                            return 'Please enter valid code!';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),

              Consumer<UserViewModel>(
                builder: (ctx, viewModel, _) => Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: viewModel.codeSent ? Text(
                    'If you are not automatically signed in after code arrives, enter it in the space provided above.',
                    textAlign: TextAlign.center,
                  ) : Container(),
                ),
              ),

              Consumer<UserViewModel>(
                  builder: (ctx, viewModel, _) =>
                      Text('Resend sms in ${viewModel.seconds} seconds')),

              // ignore: deprecated_member_use
              Consumer<UserViewModel>(
                  builder: (ctx, viewModel, _) => viewModel.resendCode
                  // ignore: deprecated_member_use
                      ? FlatButton(
                      onPressed: () {
                        viewModel.codeResend(false);
                        viewModel.phoneAuth(args['firstName'], args['lastName'], args['address'], args['phoneNumber'], context);
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(color: Colors.red),
                      ))
                      : Container()),

              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  _saveForm();
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
