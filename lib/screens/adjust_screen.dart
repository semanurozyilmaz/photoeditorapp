import 'dart:typed_data';
import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import '../providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import 'package:provider/provider.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({Key? key}) : super(key: key);

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {

  double brightnes = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;

  bool showBrightness = false;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;
  bool showReset = false;

  late ColorFilterGenerator adj;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  adjust({b, c, s, h}){
    adj = ColorFilterGenerator(
        name: 'Adjust',
        filters: [
          ColorFilterAddons.brightness(b ?? brightnes),
          ColorFilterAddons.contrast(c ?? contrast),
          ColorFilterAddons.saturation(s ?? saturation),
          ColorFilterAddons.hue(h ?? hue),
        ]
    );
  }

  showSlider({b, c, s, h}){
    setState(() {
      showBrightness = b != null ? true : false;
      showContrast = c != null ? true : false;
      showSaturation = s != null ? true : false;
      showHue = h != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        leadingWidth: 99.w,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: Image.asset(
            'assets/icons/close_button.png',
            fit: BoxFit.contain,
            height: 33.h,
            width: 33.w,
          ),
        ),
        title: Text(
          "ADJUST",
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
              Uint8List? bytes = await screenshotController.capture();
              imageProvider.changeImage(bytes!);
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
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child){
                if(value.currentImage!=null){
                  return Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(adj.matrix),
                        child: Image.memory(value.currentImage!)
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                          value: brightnes,
                          onChanged: (value){
                            setState(() {
                              brightnes = value;
                              adjust(b: brightnes);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showContrast,
                        child: slider(
                            value: contrast,
                            onChanged: (value){
                              setState(() {
                                contrast = value;
                                adjust(c: contrast);
                              });
                            }
                        ),
                      ),
                      Visibility(
                        visible: showSaturation,
                        child: slider(
                            value: saturation,
                            onChanged: (value){
                              setState(() {
                                saturation = value;
                                adjust(s: saturation);
                              });
                            }
                        ),
                      ),
                      Visibility(
                        visible: showHue,
                        child: slider(
                            value: hue,
                            onChanged: (value){
                              setState(() {
                                hue = value;
                                adjust(h: hue);
                              });
                            }
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible:  ((showBrightness == true) || (showContrast == true) || (showSaturation == true) || (showHue == true)) ? true : false,
                  child: TextButton(
                    child: Text("Reset",
                      style: TextStyle(
                          color: Palette.whiteText,
                          fontSize: Font.font15.sp,
                          fontFamily: Font.allfonts
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        brightnes = 0;
                        contrast = 0;
                        saturation = 0;
                        hue = 0;
                        adjust(
                          b: brightnes,
                          c: contrast,
                          s: saturation,
                          h: hue
                        );
                      });

                    },
                  ),
                )
              ],
            ),
          )
        ],
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
                    'assets/icons/brightness_icon.png',
                    'Brightness',
                    33.0.w,
                    onPress: () {
                      showSlider(b:true);
                    }
                ),
                _bottomItem(
                    'assets/icons/contrast_icon.png',
                    'Contrast',
                    33.0.w,
                    onPress: () {
                      showSlider(c:true);
                    }
                ),
                _bottomItem(
                    'assets/icons/saturation_icon.png',
                    'Saturation',
                    39.0.w,
                    onPress: () {
                      showSlider(s:true);
                    }
                ),
                _bottomItem(
                    'assets/icons/hue_icon.png',
                    'Hue',
                    33.0.w,
                    onPress: () {
                      showSlider(h:true);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(String icon, String title, double width, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                icon,
                fit: BoxFit.contain,
                height: 33.h,
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
  Widget slider({value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 1,
      min: -0.9,
      onChanged: onChanged,
    );
  }
}
