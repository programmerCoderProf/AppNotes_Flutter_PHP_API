import 'package:app2/constant/linkapi.dart';
import 'package:app2/models/notemodel.dart';
import 'package:flutter/material.dart';

class Cardnotes extends StatelessWidget {
  final Note notemodel;
  final void Function()? ontap;
  final void Function()? onDelete;
  const Cardnotes(
      {super.key, required this.notemodel, required this.ontap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: ontap,
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  "$LinkImageRoot/${notemodel.notesImage}",
                  fit: BoxFit.fill,
                  height: 90,
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text("${notemodel.notesTitle}"),
                  subtitle: Text("${notemodel.notesContent}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
