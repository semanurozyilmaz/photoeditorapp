import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';
import '../themes/font.dart';
import '../themes/palette.dart';

class PixelColorImage{

  show(BuildContext context, {Color? backgroundColor, Uint8List? image, onPick}){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          Color tempColor = backgroundColor!;
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  title: Text(
                    'Move your finger',
                    style: TextStyle(
                        color: Palette.blackText,
                        fontSize: Font.font15.sp,
                        fontFamily: Font.allfonts
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PixelColorPicker(
                        child: Image.memory(image!),
                        onChanged: (color) {
                          setState((){
                            tempColor = color;
                          });
                        }
                      ),
                      Container(
                        width: double.infinity,
                        height: 74.h,
                        color: tempColor
                      )
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.titleText
                      ),
                      child: Text(
                        'Cancel',
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.titleText
                      ),
                      child: Text(
                        'Pick',
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