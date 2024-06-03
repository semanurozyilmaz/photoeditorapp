import 'dart:typed_data';
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photoeditorapp/providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import 'dart:ui' as ui;

class CropScreen extends StatefulWidget{
  const CropScreen({Key? key}) : super(key:key);

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen>{

  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  late AppImageProvider imageProvider;

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        leadingWidth: 99.w,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
          child: Image.asset(
            'assets/icons/close_button.png',
            fit: BoxFit.contain,
            height: 33.h,
            width: 33.w,
          ),
        ),
        title: Text(
          "CROP/ROTATE",
          style: TextStyle(
              color: Palette.titleText,
              fontSize: Font.font24.sp,
              fontFamily: Font.allfonts
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent),
            onPressed: () async {
              ui.Image bitmap = await controller.croppedBitmap();
              ByteData? data = await bitmap.toByteData(format: ImageByteFormat.png);
              Uint8List bytes = data!.buffer.asUint8List();
              imageProvider.changeImage(bytes);
              if(!mounted) return;
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: Image.asset(
              'assets/icons/done_button.png',
              fit: BoxFit.contain,
              height: 33.h,
              width: 33.w,
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if(value.currentImage!=null){
              return CropImage(
                  controller: controller,
                  image: Image.memory(value.currentImage!),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Palette.appBarBackground,
        height: 74.h,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomItem(
                    'assets/icons/rotate_left_icon.png',
                    'Left',
                    33.0.w,
                    33.0.h,
                    19.w,
                    11.w,
                    onPress: () {
                      controller.rotateLeft();
                    }
                ),
                _bottomItem(
                    'assets/icons/rotate_right_icon.png',
                    'Right',
                    33.0.w,
                    33.0.h,
                    11.w,
                    2.w,
                    onPress: () {
                      controller.rotateRight();
                    }
                ),
                _bottomItem(
                    'assets/icons/vertical_line_icon.png',
                    '',
                    33.0.w,
                    33.0.h,
                    2.w,
                    2.w,
                    onPress: () {}
                ),
                _bottomItem2(
                    'Free',
                    2.w,
                    21.w,
                    onPress: () {
                      controller.aspectRatio = null;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
                _bottomItem(
                    'assets/icons/1_1_crop.png',
                    '1:1',
                    18.0.w,
                    18.0.h,
                    21.w,
                    21.w,
                    onPress: () {
                      controller.aspectRatio = 1;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
                _bottomItem(
                    'assets/icons/1_2_crop.png',
                    '1:2',
                    18.0.w,
                    36.0.h,
                    21.w,
                    21.w,
                    onPress: () {
                      controller.aspectRatio = 1 / 2;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
                _bottomItem(
                    'assets/icons/2_1_crop.png',
                    '2:1',
                    36.0.w,
                    18.0.h,
                    21.w,
                    21.w,
                    onPress: () {
                      controller.aspectRatio = 2;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
                _bottomItem(
                    'assets/icons/4_3_crop.png',
                    '4:3',
                    24.0.w,
                    18.0.h,
                    21.w,
                    21.w,
                    onPress: () {
                      controller.aspectRatio = 4 / 3;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
                _bottomItem(
                    'assets/icons/16_9_crop.png',
                    '16:9',
                    32.0.w,
                    18.0.h,
                    21.w,
                    20.w,
                    onPress: () {
                      controller.aspectRatio = 16 / 9;
                      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(String icon, String title, double width, double height, double l, double r, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                icon,
                fit: BoxFit.contain,
                height: height.h,
                width: width.w),
            Text(title,
              style: TextStyle(
                  color: Palette.whiteText,
                  fontSize: Font.font10.sp,
                  fontFamily: Font.allfonts
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _bottomItem2(String title, double l, double r, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.only(left:5, right:15),
        child: Text(title,
            style: TextStyle(
                color: Palette.whiteText,
                fontSize: Font.font10.sp,
                fontFamily: Font.allfonts
            ),
          ),
        ),
    );
  }
}