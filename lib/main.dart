import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:async';

void main() {
  MpesaFlutterPlugin.setConsumerKey("pgHzqlI24frgSMAeTOrzK4tyzQBDp2R9");
  MpesaFlutterPlugin.setConsumerSecret("lsjHdA9SUaEoTbAZ");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<void> lipanaMpesa(
      {required String userPhone, required double amount}) async {
    dynamic transactionInitialisation;

    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: userPhone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https",
              host: "mpesa-requestbin.herokuapp.com",
              path: "/1hhy6391"),
          accountReference: "shoe",
          phoneNumber: "254716217949",
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "purchase",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());

      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController amountEditingController2 = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textEditingController1.dispose();
    amountEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color(0xFF481E4D)),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Mpesa Payment Demo'),
            centerTitle: true,
          ),
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: textEditingController1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '+245...',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: amountEditingController2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'KES',
                  ),
                ),
              ),
              isLoading == false
                  ? ElevatedButton(
                      onPressed: () async {
                        String phone = textEditingController1.text;
                        String amount = amountEditingController2.text;

                        if (phone != null) {
                          if (phone.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            lipanaMpesa(
                                    userPhone: phone,
                                    amount: double.parse(amount))
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        } else {}
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF481E4D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: Text(
                        'Lipa na Mpesa',
                        style: TextStyle(color: Colors.white),
                      ))
                  : CircularProgressIndicator(),
            ],
          )),
        ));
  }
}
