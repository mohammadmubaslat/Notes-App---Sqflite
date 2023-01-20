import 'package:flutter/material.dart';
import 'package:noteApp/home.dart';

import 'sqldb.dart';

class editNote extends StatefulWidget {
  const editNote({this.title, this.note, this.id}) : super();
  final title;
  final note;
  final id;

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  sqlDB sqlDb = sqlDB();
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Note"),
        ),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                    key: formstate,
                    child: Column(
                      children: [
                        myTextFormField("title", title),
                        myTextFormField("note", note),
                        SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            int response = await sqlDb.updateData(''' 
                                UPDATE notes SET 
                                note = "${note.text}", 
                                title = "${title.text}"
                                WHERE id = ${widget.id}
                                ''');
                            if (response > 0)
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => home()),
                                  (route) => false);
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text("Edit note"),
                        )
                      ],
                    )),
              )
            ],
          ),
        ));
  }

  Widget myTextFormField(String data, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: "Enter the ${data} here"),
      ),
    );
  }
}
