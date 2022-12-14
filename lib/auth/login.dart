import 'package:app2/component/crud.dart';
import 'package:app2/component/valid.dart';
import 'package:app2/constant/linkapi.dart';
import 'package:flutter/material.dart';
import '../component/custometextform.dart';
import 'package:quickalert/quickalert.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isload = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formstate = GlobalKey<FormState>();

  Crud crud = Crud();
  Future login() async {
    if (_formstate.currentState!.validate()) {
      isload = true;
      setState(() {});

      var response = await crud.postRequest(LinkLogin, {
        "password": password.text,
        "email": email.text,
      });
      isload = false;
      setState(() {});
      if (response["status"] == "success") {
        QuickAlert.show(
          context: context,
          barrierDismissible: false, //press ok btn to exit from dialg
          type: QuickAlertType.success,
          text: 'Login Success',
          confirmBtnText: 'Ok',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () {
            prefs.setString("id", response['data']['id'].toString());
            prefs.setString(
                "username", response['data']['username'].toString());
            prefs.setString("email", response['data']['email'].toString());
            Navigator.of(context)
                .pushNamedAndRemoveUntil("home", (rout) => false);
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          barrierDismissible: false, //press ok btn to exit from dialg
          type: QuickAlertType.error,
          text: 'Password  Or Username Invalid',
          confirmBtnText: 'Ok',
          confirmBtnColor: Colors.green,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: isload
              ? Center(
                  child: CircularProgressIndicator(
                  semanticsLabel: "waiting...",
                  value: 6,
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://cdn.logo.com/hotlink-ok/logo-social.png",
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formstate,
                        child: Column(
                          children: [
                            CustomeFormText(
                              valid: (val) {
                                return validInput(val!, 5, 20);
                              },
                              controllers: email,
                              labeltxt: "Enter Email",
                              icon: Icon(Icons.email),
                              isSecured: false,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomeFormText(
                              valid: (val) {
                                return validInput(val!, 4, 10);
                              },
                              controllers: password,
                              labeltxt: "Enter password",
                              icon: Icon(Icons.password),
                              isSecured: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("Not have account?"),
                                TextButton(
                                  child: Text(
                                    " sing up",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("singup");
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                child: Text(" Login "),
                                onPressed: () async {
                                  await login();
                                })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
