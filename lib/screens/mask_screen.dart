import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:widget_mask/widget_mask.dart';
import '../helper/shapes.dart';
import '../helper/shapes_icon.dart';
import '../providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import '../widgets/gesture_detector_widget.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({super.key});

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {
  Uint8List? currentImage;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  BlendMode blendMode = BlendMode.dstIn;
  IconData icon = ShapesIcon().list()[0];

  double opacity = 1;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
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
          "MASK",
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
              currentImage = value.currentImage;
              return Screenshot(
                controller: screenshotController,
                child: WidgetMask(
                  childSaveLayer: true,
                  blendMode: blendMode,
                  mask: Stack(
                    children: [
                      Container(
                        color: Palette.maskBlack,
                      ),
                      GestureDetectorWidget(
                        child: Icon(
                          icon,
                          color: Palette.whiteBackground.withOpacity(opacity),
                          size: 200.w,
                        ),
                      )
                    ],
                  ),
                  child: Image.memory(value.currentImage!),
                )
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
        child: SafeArea(
          child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: (){
                            setState(() {
                              opacity = 1;
                              blendMode = BlendMode.dstIn;
                            });
                          },
                          child: Text('Dstin',
                              style: TextStyle(
                                  color: Palette.whiteText,
                                  fontSize: Font.font12.sp,
                                  fontFamily: Font.allfonts
                              )
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              blendMode = BlendMode.overlay;
                            });
                          },
                          child: Text('Overlay',
                              style: TextStyle(
                                  color: Palette.whiteText,
                                  fontSize: Font.font12.sp,
                                  fontFamily: Font.allfonts
                              )
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              opacity = 0.7;
                              blendMode = BlendMode.screen;
                            });
                          },
                          child: Text('Screen',
                              style: TextStyle(
                                  color: Palette.whiteText,
                                  fontSize: Font.font12.sp,
                                  fontFamily: Font.allfonts
                              )
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              blendMode = BlendMode.saturation;
                            });
                          },
                          child: Text('Saturation',
                              style: TextStyle(
                                  color: Palette.whiteText,
                                  fontSize: Font.font12.sp,
                                  fontFamily: Font.allfonts
                              )
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              blendMode = BlendMode.difference;
                            });
                          },
                          child: Text('Difference',
                              style: TextStyle(
                                  color: Palette.whiteText,
                                  fontSize: Font.font12.sp,
                                  fontFamily: Font.allfonts
                              )
                          )
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(int i = 0; i < Shapes().list().length; i++)
                        _bottomItem(
                            Shapes().list()[i],
                            onPress: () {
                              setState(() {
                                icon = ShapesIcon().list()[i];
                              });
                            }
                        )
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(String icon, {required onPress}){
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
                height: 33.h,
                width: 33.w),
          ],
        ),
      ),
    );
  }
}
