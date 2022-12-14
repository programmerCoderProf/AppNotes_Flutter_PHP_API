import 'dart:io';
import 'package:app2/component/custometextform.dart';
import 'package:app2/component/valid.dart';
import 'package:app2/constant/linkapi.dart';
import 'package:app2/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../component/crud.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> with Crud {
  File? myfile;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isload = false;
  addNotes() async {
    if (myfile == null)
      return QuickAlert.show(
          context: context,
          title: "Error",
          type: QuickAlertType.error,
          text: "Please select  image before send");
    if (_formKey.currentState!.validate()) {
      isload = true;
      setState(() {});
      var response = await postRequestWithFile(
          LinkAddNote,
          {
            "title": titleController.text,
            "content": contentController.text,
            "id": prefs.getString("id")
          },
          myfile!);
      isload = false;
      setState(() {});
      if (response['status'] == "success") {
        QuickAlert.show(
          context: context,
          barrierDismissible: false, //press ok btn to exit from dialg
          type: QuickAlertType.success,
          text: 'Note Added Successfully',
          confirmBtnText: 'Ok',
          onConfirmBtnTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("home", (rount) => false);
          },
          confirmBtnColor: Colors.green,
        );
      } else {
        QuickAlert.show(
          context: context,
          barrierDismissible: false, //press ok btn to exit from dialg
          type: QuickAlertType.error,
          text: 'Field',
          confirmBtnText: 'Ok',
          onConfirmBtnTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("home", (rount) => false);
          },
          confirmBtnColor: Colors.green,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        centerTitle: true,
      ),
      body: isload
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomeFormText(
                          labeltxt: "Add title Note",
                          valid: (val) {
                            return validInput(val!, 5, 20);
                          },
                          controllers: titleController,
                          isSecured: false,
                          icon: Icon(Icons.note),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            validator: (value) {
                              return validInput(value!, 5, 20);
                            },
                            controller: contentController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Content",
                              labelStyle: TextStyle(fontSize: 20),
                              prefixIcon: Icon(Icons.note),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: myfile == null ? Colors.blue : Colors.green,
                          child: ElevatedButton(
                            child: Text(
                              "Upload Image",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: showBottemSheet,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "Save Note",
                              style: TextStyle(fontSize: 22),
                            ),
                            onPressed: () async {
                              await addNotes();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  //method show galley or cam
  showBottemSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.all(20),
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Choose image",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                InkWell(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Gallery",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    XFile? xFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (xFile != null) myfile = File(xFile.path);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                InkWell(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Camera",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    XFile? xFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);

                    if (xFile != null) {
                      myfile = File(xFile.path);
                    }
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            ));
      },
    );
  }
}
