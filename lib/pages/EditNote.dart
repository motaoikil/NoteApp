import 'package:flutter/material.dart';
import 'package:notes_app/Classes/MyCode.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';

class Editnote extends State<MyApp> {
  static final titleco = new TextEditingController();
  static final noteco = new TextEditingController();
  static final _key = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MyCode logo = new MyCode(
        Width_Pc: 30,
        Heigth_Pc: 18,
        Width_Phone: 25,
        Heigth_Phone: 17,
        context: context);
    MyCode WhiteContainer = new MyCode(
        Width_Pc: 80,
        Heigth_Pc: 60,
        Width_Phone: 55,
        Heigth_Phone: 70,
        context: context);
    Map Data = ModalRoute.of(context)!.settings.arguments as Map;

    titleco.text = Data["TITRE"].toString();
    noteco.text = Data["NOTE"].toString();
    var id = Data["ID_NOTE"].toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit note"),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (Navigator.canPop(context))
                ? (Expanded(
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              (Navigator.canPop(context)
                                  ? (Navigator.pop(context))
                                  : (null));
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      )
                    ],
                  )))
                : (Text("")),
          ],
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/add.png"), fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: WhiteContainer.GetWidth(),
              // height: WhiteContainer.GetHeight(),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage("images/logo.png"),
                      width: logo.GetWidth(),
                      height: logo.GetHeight(),
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          validator: ((value) {
                            value = value.toString().trim();
                            if (value.length < 3) {
                              return "this box is null";
                            }
                          }),
                          controller: titleco,
                          maxLength: 30,
                          decoration: InputDecoration(
                              hintMaxLines: 1,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.drive_file_rename_outline_outlined,
                              ),
                              label: Text("Title:")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: ((value) {
                            value = value.toString().trim();
                            if (value.length < 3) {
                              return "this box is null";
                            }
                          }),
                          controller: noteco,
                          maxLines: 50,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.description_outlined,
                              ),
                              label: Text("Note:")),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        String note = noteco.text, title = titleco.text;
                        if (_key.currentState!.validate()) {
                          await MySqldatabase().update(
                              "update note set TITRE=?, NOTE=? where ID_NOTE=?",
                              [title, note, id]);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("successfully"),
                            action: SnackBarAction(
                                onPressed: () {}, label: "close"),
                          ));
                          Navigator.pushReplacementNamed(context, "HomePage");
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.update_outlined,
                              color: Theme.of(context).primaryIconTheme.color,
                              size: Theme.of(context).primaryIconTheme.size,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Edit note",
                              style: Theme.of(context).primaryTextTheme.button,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
