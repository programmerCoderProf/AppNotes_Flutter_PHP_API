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

class EditNote extends StatefulWidget {
  final notes;
  const EditNote({super.key, this.notes});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with Crud {
  var imagename = "";
  @override
  void initState() {
    titleController.text = widget.notes['notes_title'];
    contentController.text = widget.notes['notes_content'];
    imagename = widget.notes['notes_image'];
    super.initState();
  }

  File? myfile;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isload = false;
  EditNote() async {
    if (_formKey.currentState!.validate()) {
      isload = true;
      setState(() {});
      var response;
      if (myfile == null) {
        response = await postRequest(
          LinkEditNote,
          {
            "title": titleController.text,
            "content": contentController.text,
            "id": widget.notes['notes_id'].toString(),
            "imagename": widget.notes['notes_image'].toString()
          },
        );
      } else {
        response = await postRequestWithFile(
          LinkEditNote,
          {
            "title": titleController.text,
            "content": contentController.text,
            "imagename": widget.notes['notes_image'].toString(),
            "id": widget.notes['notes_id'].toString()
          },
          myfile!,
        );
      }

      isload = false;
      setState(() {});
      if (response['status'] == "success") {
        QuickAlert.show(
          context: context,
          barrierDismissible: false, //press ok btn to exit from dialg
          type: QuickAlertType.success,
          text: 'Note updated Successfully',
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
        title: Text("Edit Note"),
        centerTitle: true,
      ),
      body: isload
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
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
                            height: 400,
                            padding: EdgeInsets.all(10),
                            child: Image.network(
                              "$LinkImageRoot/${imagename}",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myfile == null
                                      ? Colors.blue
                                      : Colors.green),
                              child: Text(
                                "Edit Image",
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
                                "Save Changes",
                                style: TextStyle(fontSize: 22),
                              ),
                              onPressed: () async {
                                await EditNote();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                    Navigator.of(context).pop();
                    if (xFile != null) myfile = File(xFile.path);
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
                    Navigator.of(context).pop();
                    if (xFile != null) myfile = File(xFile.path);
                    setState(() {});
                  },
                ),
              ],
            ));
      },
    );
  }
}
