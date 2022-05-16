import 'package:flutter/material.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends State<MyApp> {
  String name = "test", lastname = "test", email = "test";
  var id;
  _getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    id = await sh.getString("ID_USER")!;
    List data = await MySqldatabase()
        .user_select("select * from user where ID_USER=?", [id]);
    name = data[0]["NAME"];
    lastname = data[0]["LASTNAME"];
    email = data[0]["EMAIL"];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getdata(),
      builder: (context, snapshot) => (!snapshot.hasData)
          ? Center(child: CircularProgressIndicator())
          : Drawer(
              child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      name.substring(0, 1).toUpperCase() +
                          lastname.substring(0, 1).toUpperCase(),
                      style: Theme.of(context).primaryTextTheme.headline1,
                    ),
                  ),
                  accountName: Text(
                    "${name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase()} ${lastname.substring(0, 1).toUpperCase() + lastname.substring(1).toLowerCase()}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(email,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      MaterialButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3)),
                        onPressed: () {
                          Navigator.pushNamed(context, "Settings");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Settings",
                                style:
                                    Theme.of(context).primaryTextTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3)),
                        onPressed: () async {
                          SharedPreferences sh =
                              await SharedPreferences.getInstance();
                          sh.clear();
                          Navigator.pushReplacementNamed(context, "Login");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Log out",
                                style:
                                    Theme.of(context).primaryTextTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
