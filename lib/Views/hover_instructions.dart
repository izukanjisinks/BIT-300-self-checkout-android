import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Widgets/custom_bottom_sheet.dart';

class FAQS extends StatelessWidget {
  static const routeName = 'faqs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.deepPurple,),onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.white,
        title: Text(
          'Frequently asked questions',
          style:
          TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){bottomSheet(context);}, icon: Icon(Icons.sms_rounded,color: Colors.deepPurple,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                '1. How can I enable mobile money payment on E-Store?',
                style: TextStyle(fontSize: 16.0, color: Colors.deepPurple,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0,),
              Text(
                'To enable mobile money payment, follow the step-by-step guide below:',
                style: TextStyle( color: Colors.black45),
              ),
              SizedBox(height: 45.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(1) ',
                    style: TextStyle( color: Colors.deepPurple),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'First grant permission for the application to Read SIM and make and manage phone calls to ensure proper SIM detection and initiate the USSD session through the dialer',
                      style: TextStyle( color: Colors.black45,fontSize: 16.0,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Center(child: Image.asset('assets/instructions/smsPermission1.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 20.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(2) ',
                    style: TextStyle( color: Colors.deepPurple),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Show drawing overlay to show the processing screen while the transaction automates in the background, this will open your phone settings where you can enable this permission',
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),

              Center(child: Image.asset('assets/instructions/overlayPermission2.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 20.0,),
              Center(
                child: Text(
                  'Enable the permission by toggle the button shown below:',
                  style: TextStyle(fontSize: 16.0, color: Colors.black45),
                ),
              ),
              SizedBox(height: 20.0,),
              Center(child: Image.asset('assets/instructions/overlayPermission3.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 20.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(3) ',
                    style: TextStyle( color: Colors.deepPurple),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'Use accessibility services to complete USSD session on behalf of the user',
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),
                    ),
                  ),
                ],
              ),
              Center(child: Image.asset('assets/instructions/accessibilityPermission4.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 15.0,),
              Text(
                'This will open phone settings, tap on installed services as shown below:',
                style: TextStyle(fontSize: 16.0, color: Colors.black45),
              ),
              SizedBox(height: 15.0,),
              Center(child: Image.asset('assets/instructions/accessibilityPermission5.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 15.0,),
              Text(
                'Navigate to E-Store and top on it to enable accessibility permission',
                style: TextStyle(fontSize: 16.0, color: Colors.black45),
              ),
              SizedBox(height: 15.0,),
              Center(child: Image.asset('assets/instructions/accessibilityPermission6.jpg',width: MediaQuery.of(context).size.width * 0.5,)),
              SizedBox(height: 15.0,),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'If you are having issues after this contact admin by clicking the icon on the top right corner',
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) {
    showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (context){
      return  CustomBottomSheet(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      radius: 40.0,
                      child: Icon(Icons.account_circle,size: 90.0,),
                      backgroundColor: Colors.transparent,
                    )
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'E-Store Admin',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  height: 7.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cell: ',
                      style:
                      TextStyle(color: Colors.black54, fontSize: 16.0),
                    ),
                    Text(
                      '+260969678808',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    //SizedBox(width: 15.0,),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.deepPurple,
                        onPressed: () async {
                          String phoneNumber = '0969678808';
                          var phone =
                              'tel:$phoneNumber';
                          if (await canLaunch(phone)) {
                            await launch(phone);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                'Failed to call given number!',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.deepPurple,
                            ));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                        icon: Icon(Icons.messenger),
                        color: Colors.deepPurple,
                        onPressed: () async{
                          String phoneNumber = '0969678808';
                          var message = 'sms:'+ phoneNumber + '?body=';
                          if (await canLaunch(message)) {
                            await launch(message);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                'Failed to send message!',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.deepPurple,
                            ));
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String phoneNumber = '0969678808';
                        var whatsAppUrl =
                            "whatsapp://send?phone=" + phoneNumber+"&text= ";
                        if (await canLaunch(whatsAppUrl)) {
                          await launch(whatsAppUrl);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                            content: Text(
                              'Failed to launch WhatsApp!',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.deepPurple,
                          ));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          width: 30.0,
                          child:
                          Image.asset('assets/icons/whatsapp-icon.png'),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),),
      );
    });
  }


}
