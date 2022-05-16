import 'package:flutter/material.dart';
import 'package:notes_app/Classes/MyCode.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends State<MyApp> {
  static GlobalKey<FormState> _key = new GlobalKey<FormState>();

  final emailco = new TextEditingController();
  final passwordco = new TextEditingController();
  final nameco = new TextEditingController();
  final lastenameco = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyCode logo = new MyCode(
        Width_Pc: 25,
        Heigth_Pc: 15,
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
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/notes.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              width: WhiteContainer.GetWidth(),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: AssetImage("images/logo.png"),
                    width: logo.GetWidth(),
                    height: logo.GetHeight(),
                    fit: BoxFit.fill,
                  ),
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: nameco,
                          validator: (val) {
                            val = val.toString().trim();
                            RegExp Re = new RegExp("^([A-Za-z]{4,})\$");
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
                              label: Text("Enter your name")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: lastenameco,
                          validator: (val) {
                            val = val.toString().trim();
                            RegExp Re = new RegExp("^([A-Za-z]{4,})\$");
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
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailco,
                          validator: (val) {
                            val = val.toString().trim();
                            RegExp Re = new RegExp(
                                "^([A-Za-z]{4,}[0-9]*@((gmail.com)|(hotmail.(com|fr))))\$");
                            if (!Re.hasMatch(val)) {
                              return "incorrect format";
                            }
                          },
                          maxLength: 30,
                          decoration: InputDecoration(
                              hintMaxLines: 1,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                              label: Text("Enter your email adress")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passwordco,
                          validator: (val) {
                            val = val.toString();
                            if (val.length < 8) {
                              return "eight or more letters";
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
                              label: Text("Enter your password")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (val) {
                            val = val.toString();
                            if (val.length < 8) {
                              return "eight or more letters";
                            }
                            if (val != passwordco.text) {
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
                              label: Text("Confirmed your password")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("if you have account click here"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "Login");
                                },
                                child: Text("Loging in your account"))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () async {
                            try {
                              String email = "",
                                  password = "",
                                  name = "",
                                  lastname = "";
                              if (_key.currentState!.validate()) {
                                email = emailco.text;
                                password = passwordco.text;
                                name = nameco.text;
                                lastname = lastenameco.text;
                                password = passwordco.text;

                                List dat = await MySqldatabase().user_select(
                                    "select * from user where EMAIL=?",
                                    [email]);
                                if (dat.isEmpty) {
                                  MySqldatabase my = MySqldatabase();
                                  await my.insert(
                                      "insert into user (EMAIL,PASSWORD,NAME,LASTNAME) values(?,?,?,?)",
                                      [email, password, name, lastname]);
                                  List dat = await MySqldatabase().user_select(
                                      "select * from user where EMAIL=?",
                                      [email]);
                                  SharedPreferences sh =
                                      await SharedPreferences.getInstance();
                                  sh.clear();
                                  sh.setString(
                                      "ID_USER", dat[0]["ID_USER"].toString());
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("successfully"),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                        onPressed: () {}, label: "close"),
                                  ));
                                  Navigator.pushReplacementNamed(
                                      context, "HomePage");
                                } else {
                                  try {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                              "\u{26A0} This email is already in use",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            title: Text("Error"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("close"))
                                            ],
                                          );
                                        });
                                  } catch (e) {}
                                }
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
                                  Icons.login,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                  size: Theme.of(context).primaryIconTheme.size,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Sing in",
                                  style:
                                      Theme.of(context).primaryTextTheme.button,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
