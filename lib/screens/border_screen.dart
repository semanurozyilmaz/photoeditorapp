import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/app_color_picker.dart';
import '../helper/pixel_color_image.dart';
import '../providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import 'package:flutter/foundation.dart';

class BorderEditScreen extends StatefulWidget {
  const BorderEditScreen({Key? key}) : super(key: key);

  @override
  State<BorderEditScreen> createState() => _BorderEditScreenState();
}

class _BorderEditScreenState extends State<BorderEditScreen> {
  double _borderThickness = 5.0;
  double _borderRadius = 0.0;
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? mainImage;
  Color borderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<AppImageProvider>(context);

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        leadingWidth: 99.w,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
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
          "BORDER",
          style: TextStyle(
            color: Palette.titleText,
            fontSize: Font.font24.sp,
            fontFamily: Font.allfonts,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: () async {
              Uint8List? bytes = await screenshotController.capture();
              imageProvider.changeImage(bytes!);
              if (!mounted) return;
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
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              mainImage = value.currentImage;
              return Screenshot(
                controller: screenshotController,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: _borderThickness),
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_borderRadius- _borderThickness),
                    child: Image.memory(imageProvider.currentImage!),
                  ),
                ),
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
        height: 111.h,
        child: Expanded(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 31.h,
                    color: Palette.appBarBackground,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              AppColorPicker().show(
                                  context,
                                  backgroundColor: borderColor,
                                  onPick: (color){
                                    setState(() {
                                      borderColor = color;
                                    });
                                  }
                              );
                            },
                            child: Image.asset(
                                'assets/icons/color_palette_icon.png',
                                fit: BoxFit.contain,
                                height: 22.h,
                                width: 22.w
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              PixelColorImage().show(
                                  context,
                                  backgroundColor: borderColor,
                                  image: mainImage,
                                  onPick: (color){
                                    setState(() {
                                      borderColor = color;
                                    });
                                  }
                              );
                            },
                            child: Image.asset(
                                'assets/icons/color_dropper_icon.png',
                                fit: BoxFit.contain,
                                height: 22.h,
                                width: 22.w
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40.h,
                  child: Row(
                    children: [
                      Center(child: Text("Thickness", style: TextStyle(color: Palette.whiteText, fontSize: Font.font12.sp))),
                      Expanded(
                        child: Slider(
                          value: _borderThickness,
                          min: 0.0,
                          max: 50.0,
                          onChanged: (value) {
                            setState(() {
                              _borderThickness = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40.h,
                  child: Row(
                    children: [
                      Center(child: Text("Radius", style: TextStyle(color: Palette.whiteText,fontSize: Font.font12.sp))),
                      Expanded(
                        child: Slider(
                          value: _borderRadius,
                          min: 0.0,
                          max: 100.0,
                          onChanged: (value) {
                            setState(() {
                              _borderRadius = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}