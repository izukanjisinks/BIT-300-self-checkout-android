import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hover_ussd/hover_ussd.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_application/Model/cart_model.dart';
import 'package:self_checkout_application/Model/notification_overlay.dart';
import 'package:self_checkout_application/Model/notifications_provider.dart';
import 'package:self_checkout_application/Model/searchModel.dart';
import 'package:self_checkout_application/Model/user_model.dart';
import 'package:self_checkout_application/ViewModel/history_view_model.dart';
import 'package:self_checkout_application/ViewModel/searchViewModel.dart';
import 'package:self_checkout_application/ViewModel/user_view_model.dart';
import 'package:self_checkout_application/Views/hover_instructions.dart';
import 'package:self_checkout_application/Views/notifications_screen.dart';
import 'package:self_checkout_application/Views/phone_authentication.dart';
import 'package:self_checkout_application/Views/welcome_page.dart';

import './Model/get_product_model.dart';
import './ViewModel/cart_view_model.dart';
import './ViewModel/get_product_vew_model.dart';
import './Views/create_account_page.dart';
import './Views/fetch_product.dart';
import './Views/home_page.dart';
import './Views/scan_product_page.dart';
import 'Model/history_model.dart';
import 'Model/wifi_model.dart';
import 'ViewModel/user_account_view_model.dart';
import 'Views/Widgets/dialogs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HoverUssd.initialize(branding: 'Hover Ussd Example', logo: "mipmap/ic_launcher");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    NotificationOverlay().registerNotification(context);
    super.initState();
  }


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartViewModel()),
        ChangeNotifierProvider(create: (ctx) => CartModel()),
        ChangeNotifierProvider(create: (ctx) => GetProductViewModel()),
        ChangeNotifierProvider(create: (ctx) => GetProductModel()),
        ChangeNotifierProvider(create: (ctx) => UserViewModel()),
        ChangeNotifierProvider(create: (ctx) => UserModel()),
        ChangeNotifierProvider(create: (ctx) => UserAccountModel()),
        ChangeNotifierProvider(create: (ctx) => HistoryViewModel()),
        ChangeNotifierProvider(create: (ctx) => HistoryModel()),
        ChangeNotifierProvider(create: (ctx) => SearchViewModel()),
        ChangeNotifierProvider(create: (ctx) => SearchModel()),
        ChangeNotifierProvider(create: (ctx) => WifiModel()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Welcome(),
          routes: {
            FetchProduct.routeName: (ctx) => FetchProduct(),
            ScanPage.routeName: (ctx) => ScanPage(),
            CreateAccount.routeName: (ctx) => CreateAccount(),
            HomePage.routeName: (ctx) => HomePage(),
            PhoneAuth.routeName: (ctx) => PhoneAuth(),
            FAQS.routeName: (ctx) => FAQS(),
            Notifications.routeName: (ctx) => Notifications(),
          },
        ),
      ),
    );
  }
}

