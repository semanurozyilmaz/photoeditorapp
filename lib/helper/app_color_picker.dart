import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/font.dart';
import '../themes/palette.dart';

class AppColorPicker{

  show(BuildContext context, {Color? backgroundColor, Uint8List? image, onPick}){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          Color tempColor = backgroundColor!;
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  title: Text(
                    'Pick a color',
                    style: TextStyle(
                        color: Palette.blackText,
                        fontSize: Font.font15.sp,
                        fontFamily: Font.allfonts
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: HueRingPicker(
                      enableAlpha: false,
                      pickerColor: backgroundColor,
                      onColorChanged: (color) {
                        tempColor = color;
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.titleText
                      ),
                      child: Text(
                        'Got it',
                        style: TextStyle(
                            color: Palette.blackText,
                            fontSize: Font.font12.sp,
                            fontFamily: Font.allfonts
                        ),
                      ),
                      onPressed: () {
                        onPick(tempColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }
}