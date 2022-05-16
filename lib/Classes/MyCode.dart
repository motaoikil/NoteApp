import 'dart:io';

import 'package:flutter/material.dart';

class MyCode {
  double Width_Pc, Heigth_Pc, Width_Phone, Heigth_Phone;
  BuildContext context;
  MyCode(
      {required this.Width_Pc,
      required this.Heigth_Pc,
      required this.Width_Phone,
      required this.Heigth_Phone,
      required this.context});

  double GetWidth() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return (MediaQuery.of(context).size.height) * (this.Width_Phone / 100);
      } else {
        return (MediaQuery.of(context).size.height) * (this.Width_Pc / 100);
      }
    } catch (Ex) {
      return (MediaQuery.of(context).size.height) * (this.Width_Pc / 100);
    }
  }

  double GetHeight() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return (MediaQuery.of(context).size.height) * (this.Heigth_Phone / 100);
      } else {
        return (MediaQuery.of(context).size.height) * (this.Heigth_Pc / 100);
      }
    } catch (ex) {
      return (MediaQuery.of(context).size.height) * (this.Heigth_Pc / 100);
    }
  }
}
