import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photoeditorapp/themes/font.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoeditorapp/helper/app_image_picker.dart';
import '../providers/app_image_provider.dart';
import 'package:photoeditorapp/themes/palette.dart';

class StartScreen extends StatefulWidget{
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late AppImageProvider imageProvider;

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              width:  double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/main_screen.png',
                fit: BoxFit.fill,
              )
          ),
          Column(
            children:[
              Container(height:478.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(width:41.w),
                    InkWell(
                      onTap: () {
                        AppImagePicker(source: ImageSource.gallery)
                            .pick(onPick: (File? image){
                              imageProvider.changeImageFile(image!);
                              Navigator.of(context).pushReplacementNamed('/home');
                        });
                      }, // needed
                      child: Image.asset(
                        'assets/icons/gallery_icon.png',
                        width: 71.w,
                        height: 54.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(width:200.w),
                    InkWell(
                      onTap: (){
                        AppImagePicker(source: ImageSource.camera)
                            .pick(onPick: (File? image){
                          imageProvider.changeImageFile(image!);
                          Navigator.of(context).pushReplacementNamed('/home');
                        });
                      }, // needed
                      child: Image.asset(
                        'assets/icons/camera_icon.png',
                        width: 66.81.w,
                        height: 54.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(width:27.19.w),
                  ],
                ),
             Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(width:41.w),
                    SizedBox(
                      width: 71.w,
                      child: Center(
                        child: Text(
                          "GALLERY",
                          style: TextStyle(
                            color: Palette.blackText,
                            fontSize: Font.font12.sp,
                            fontFamily: Font.allfonts
                          ),
                        ),
                      ),
                    ),
                    Container(width:200.w),
                    SizedBox(
                      width: 66.81.w,
                      child: Center(
                        child: Text(
                          "CAMERA",
                          style: TextStyle(
                            color: Palette.blackText,
                            fontSize: Font.font12.sp,
                            fontFamily: Font.allfonts
                          ),
                        ),
                      ),
                    ),
                    Container(width:27.19.w),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
