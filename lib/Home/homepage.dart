import 'package:app2/component/cardnote.dart';
import 'package:app2/component/crud.dart';
import 'package:app2/constant/linkapi.dart';
import 'package:app2/crud/edit.dart';
import 'package:app2/main.dart';
import 'package:app2/models/notemodel.dart';
import 'package:flutter/material.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Crud {
  Future getNotes() async {
    var response =
        await postRequest(LinkViewAllNotes, {"id": prefs.getString("id")});
    print(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (_) => false);
                  prefs.clear();
                },
                icon: Icon(Icons.exit_to_app),
              )
            ],
            centerTitle: true,
            title: Text("Home Page"),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("addnotes");
            },
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                FutureBuilder(
                  future: getNotes(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                          child: Text("no notes Found"),
                        );
                      return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Cardnotes(
                            notemodel:
                                Note.fromJson(snapshot.data['data'][index]),
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditNote(
                                        notes: snapshot.data['data'][index],
                                      )));
                            },
                            onDelete: () async {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                barrierDismissible: false,
                                text: 'This note will be deleted permanently?',
                                confirmBtnText: 'Ok',
                                showCancelBtn: true,
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () async {
                                  var response = await postRequest(
                                    LinkDeleteNote,
                                    {
                                      "id": snapshot.data['data'][index]
                                              ['notes_id']
                                          .toString(),
                                      "imagename": snapshot.data['data'][index]
                                              ['notes_image']
                                          .toString()
                                    },
                                  );

                                  setState(() {});
                                  if (response['status'] == 'success') {
                                    Navigator.of(context).pop();
                                  }
                                },
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: Text("Loading"),
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
}
