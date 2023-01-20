import 'package:flutter/material.dart';
import 'package:noteApp/home.dart';

import 'sqldb.dart';

class addNote extends StatefulWidget {
  const addNote({Key? key}) : super(key: key);

  @override
  State<addNote> createState() => _addNoteState();
}

class _addNoteState extends State<addNote> {
  sqlDB sqlDb = sqlDB();
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Note"),
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
                            int response = await sqlDb.insertData(''' 
                                INSERT INTO notes (`note`, `title`)
                                VALUES ("${note.text}","${title.text}" )
                                ''');
                            if (response > 0)
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => home()),
                                  (route) => false);
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text("Add note"),
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
