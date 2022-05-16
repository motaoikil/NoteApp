import 'package:flutter/material.dart';
import 'package:notes_app/Classes/MyCode.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends State<MyApp> {
  final emailco = new TextEditingController();
  final passwordco = new TextEditingController();
  bool eroor = false;
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();

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
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/notes.jpg"), fit: BoxFit.cover)),
        child:
            //
            Center(
          child: Container(
            width: WhiteContainer.GetWidth(),
            // height: WhiteContainer.GetHeight(),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
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
                  (eroor)
                      ? (Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\u{26A0} Email or password is incorrect",
                            style: TextStyle(color: Colors.red),
                          )))
                      : SizedBox(
                          height: 0,
                        ),
                  Form(
                    key: _key,
                    onChanged: () {},
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailco,
                          onChanged: (value) {},
                          validator: (val) {
                            val = val.toString().trim();
                            RegExp exp = new RegExp(
                                "^([A-Za-z]{6,}\w*@(gmail.com|(hotmail.(com|fr))))\$");
                            if (val.isEmpty)
                              return "this email text box is emty";
                            else if (!exp.hasMatch(val))
                              return "incorrect format";
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
                          onChanged: (value) {},
                          controller: passwordco,
                          validator: (val) {
                            if (val.toString().isEmpty)
                              return "this password text box is empty";
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
                        Column(
                          children: [
                            Text("if you don't have account click here"),
                            TextButton(
                                onPressed: () {
                                  emailco.clear();
                                  passwordco.clear();
                                  Navigator.pushNamed(context, "Register");
                                },
                                child: Text("Create new account"))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async {
                      try {
                        String email = "", password = "";
                        if (_key.currentState!.validate()) {
                          email = emailco.text;
                          password = passwordco.text;
                          List dat = await MySqldatabase().user_select(
                              "select * from user where PASSWORD=? and EMAIL=?",
                              [password, email]);
                          if (dat.isNotEmpty) {
                            SharedPreferences sh =
                                await SharedPreferences.getInstance();
                            sh.clear();
                            sh.setString(
                                "ID_USER", dat[0]["ID_USER"].toString());

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("successfully"),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                  onPressed: () {}, label: "close"),
                            ));
                            emailco.clear();
                            passwordco.clear();
                            Navigator.pushReplacementNamed(context, "HomePage");
                          } else {
                            setState(() {
                              emailco.clear();
                              passwordco.clear();
                              eroor = true;
                            });
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.login,
                            color: Theme.of(context).primaryIconTheme.color,
                            size: Theme.of(context).primaryIconTheme.size,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Log in",
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
    );
  }
}
