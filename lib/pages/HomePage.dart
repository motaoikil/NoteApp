import 'package:flutter/material.dart';
import 'package:notes_app/Classes/MyDrawer.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends State<MyApp> {
  _getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var id = await sh.getString("ID_USER")!;
    List data = await MySqldatabase().note_select(
        "select * from note where ID_USER=?", [id]);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ziko Notes"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "AddNote");
          },
          child: Icon(Icons.note_add_outlined,
              color: Theme.of(context).primaryIconTheme.color),
        ),
        drawer: MyDrawer().build(context),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else {
              List data = snapshot.data as List;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    
                    return Dismissible(
                        background: Card(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )),
                        key: Key("$index"),
                        onDismissed: (vall) async {
                          await MySqldatabase().delete(
                              "delete from note where ID_NOTE=?",
                              [data[index]["ID_NOTE"].toString()]);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("successfully"),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                                onPressed: () {}, label: "close"),
                          ));
                        },
                        child: Card(
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, "Editnote",
                                    arguments: {
                                      "ID_NOTE": data[index]["ID_NOTE"],
                                      "TITRE": data[index]["TITRE"],
                                      "NOTE": data[index]["NOTE"]
                                    });
                              },
                            ),
                            title: Text(data[index]["TITRE"]),
                            subtitle: Text(
                                data[index]["NOTE"].toString().substring(0, 2) +
                                    "..."),
                          ),
                        ));
                  }));
            }
          },
          future: _getdata(),
        ));
  }
}
