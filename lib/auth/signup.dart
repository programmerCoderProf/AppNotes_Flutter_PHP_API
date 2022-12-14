import 'package:app2/component/crud.dart';
import 'package:app2/component/valid.dart';
import 'package:app2/constant/linkapi.dart';
import 'package:flutter/material.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../component/custometextform.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  GlobalKey<FormState> _formstate = GlobalKey();
  bool isload = false;
  Crud _crud = Crud();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  singUp() async {
    if (_formstate.currentState!.validate()) {
      setState(() {
        isload = true;
      });
      var respone = await _crud.postRequest(LinkSingUp, {
        "username": username.text,
        "email": email.text,
        "password": password.text,
      });
      isload = false;
      if (respone['status'] == "success") {
        QuickAlert.show(
          autoCloseDuration: Duration(seconds: 10),
          context: context,
          showCancelBtn: false,
          type: QuickAlertType.success,
          text: 'Account Created Successfully',
          confirmBtnText: 'Ok',
          confirmBtnColor: Colors.green,
        )..then((val) async {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("login", (route) => false);
          });
      } else {
        QuickAlert.show(
            autoCloseDuration: Duration(seconds: 4),
            context: context,
            showCancelBtn: false,
            type: QuickAlertType.error,
            text: 'Sure your internet is connected',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green);
      }
    } else {
      print("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isload == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
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
                              return validInput(val!, 4, 10);
                            },
                            controllers: username,
                            labeltxt: "Enter username",
                            icon: Icon(Icons.person),
                            isSecured: false,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomeFormText(
                            valid: (val) {
                              return validInput(val!, 10, 30);
                            },
                            controllers: email,
                            labeltxt: "Enter email",
                            icon: Icon(Icons.email),
                            isSecured: false,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomeFormText(
                            labeltxt: "Enter password",
                            valid: (val) {
                              return validInput(val!, 4, 10);
                            },
                            controllers: password,
                            icon: Icon(Icons.person),
                            isSecured: false,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text("if you have account?"),
                              TextButton(
                                child: Text(
                                  " sing in",
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed("login");
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            child: Text("Create"),
                            onPressed: () async {
                              await singUp();
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
