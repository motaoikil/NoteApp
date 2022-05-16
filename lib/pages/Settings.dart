import 'package:flutter/material.dart';
import 'package:notes_app/Classes/MyCode.dart';
import 'package:notes_app/Classes/MyDrawer.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends State<MyApp> {
  static final emailco = new TextEditingController();
  static final newpasswordco = new TextEditingController();
  static final lastpasswordco = new TextEditingController();
  static final nameco = new TextEditingController();
  static final lastnameco = new TextEditingController();
  static final _key = new GlobalKey<FormState>();
  late String lastpassword;
  var id;
  _getdata() async {
    id = (await SharedPreferences.getInstance()).getString("ID_USER");

    List data = await MySqldatabase()
        .user_select("SELECT * from user where ID_USER=?", [id]);
    nameco.text = data[0]["NAME"];
    lastnameco.text = data[0]["LASTNAME"];
    emailco.text = data[0]["EMAIL"];
    lastpassword = data[0]["PASSWORD"];
    return data;
  }

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
        Heigth_Pc: 80,
        Width_Phone: 55,
        Heigth_Phone: 70,
        context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
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
                            icon: Icon(Icons.arrow_back_ios_new)),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      )
                    ],
                  )))
                : (Text(""))
          ],
        ),
      ),
      drawer: MyDrawer().build(context),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/notes.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              width: WhiteContainer.GetWidth(),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage("images/logo.png"),
                        width: logo.GetWidth(),
                        height: logo.GetHeight(),
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                        future: _getdata(),
                        builder: (context, snapshot) {
                          return (!snapshot.hasData)
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    TextFormField(
                                      validator: (val) {
                                        val = val.toString().trim();
                                        RegExp Re =
                                            new RegExp("^([A-Za-z]{4,})\$");
                                        if (val.length < 4)
                                          return "Four or more letters";
                                        else if (!Re.hasMatch(val)) {
                                          return "only letters";
                                        }
                                      },
                                      controller: nameco,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        hintMaxLines: 1,
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.face,
                                        ),
                                        label: Text("Enter your name"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: lastnameco,
                                      validator: (val) {
                                        val = val.toString().trim();
                                        RegExp Re =
                                            new RegExp("^([A-Za-z]{4,})\$");
                                        if (val.length < 4)
                                          return "Four or more letters";
                                        else if (!Re.hasMatch(val)) {
                                          return "only letters";
                                        }
                                      },
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.face,
                                          ),
                                          label: Text("Enter your lastname")),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        val = val.toString().trim();
                                        RegExp Re = new RegExp(
                                            "^([A-Za-z]{4,}[0-9]*@((gmail.com)|(hotmail.(com|fr))))\$");
                                        if (!Re.hasMatch(val)) {
                                          return "incorrect format";
                                        }
                                      },
                                      controller: emailco,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                          ),
                                          label:
                                              Text("Enter your email adress")),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        val = val.toString();
                                        if (val != lastpassword) {
                                          return "Last password is incorrect";
                                        }
                                      },
                                      controller: lastpasswordco,
                                      obscureText: true,
                                      maxLength: 12,
                                      decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                          ),
                                          label: Text("Enter last password")),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        val = val.toString();
                                        if (val.length < 8) {
                                          return "eight or more letters";
                                        }
                                      },
                                      controller: newpasswordco,
                                      obscureText: true,
                                      maxLength: 12,
                                      decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                          ),
                                          label: Text("Enter new password")),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        val = val.toString();
                                        if (val.length < 8) {
                                          return "eight or more letters";
                                        } else if (val != newpasswordco.text) {
                                          return "password different to confirmation";
                                        }
                                      },
                                      obscureText: true,
                                      maxLength: 12,
                                      decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                          ),
                                          label:
                                              Text("Confirmed new password")),
                                    ),
                                  ],
                                );
                        },
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          try {
                            if (_key.currentState!.validate()) {
                              MySqldatabase mysql = await MySqldatabase();
                              await mysql.update(
                                  "UPDATE user SET NAME=?, LASTNAME=?, EMAIL=?, PASSWORD=? WHERE ID_USER=?",
                                  [
                                    nameco.text,
                                    lastnameco.text,
                                    emailco.text,
                                    newpasswordco.text,
                                    id.toString()
                                  ]);
                              Navigator.pushReplacementNamed(
                                  context, "HomePage");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("successfully"),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                    onPressed: () {}, label: "close"),
                              ));
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.update_sharp,
                                color: Theme.of(context).primaryIconTheme.color,
                                size: Theme.of(context).primaryIconTheme.size,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Update",
                                style:
                                    Theme.of(context).primaryTextTheme.button,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
