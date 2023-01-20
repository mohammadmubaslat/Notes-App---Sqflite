import 'package:flutter/material.dart';
import 'package:noteApp/edit_note.dart';
import 'package:noteApp/sqldb.dart';
import 'package:sqflite/sqflite.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  sqlDB sqlDb = sqlDB();
  bool isLoading = true;
  List notes = [];

  Future<List<Map>> readDate() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) setState(() {});
    return response;
  }

  @override
  void initState() {
    readDate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Home Page",
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          },
          child: Icon(Icons.add),
        ),
        body: isLoading == true
            ? CircularProgressIndicator()
            : Container(
                child: ListView(
                  children: [
                    ListView.builder(
                        itemCount: notes.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Card(
                            child: ListTile(
                                title: Text("${notes[i]['title']}"),
                                subtitle: Text("${notes[i]['note']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => editNote(
                                                      title: notes[i]['title'],
                                                      note: notes[i]['note'],
                                                      id: notes[i]['id'],
                                                    )));
                                      },
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () async {
                                          int response = await sqlDb.deleteData(
                                              "DELETE FROM notes WHERE id = ${notes[i]['id']}");
                                          if (response > 0) {
                                            notes.removeWhere((element) =>
                                                element['id'] ==
                                                notes[i]['id']);
                                            setState(() {});
                                          }
                                        }),
                                  ],
                                )),
                          );
                        }),
                  ],
                ),
              ));
  }
}
