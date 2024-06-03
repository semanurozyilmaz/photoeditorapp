import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';
import '../helper/app_color_picker.dart';
import '../helper/pixel_color_image.dart';
import '../providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  Uint8List? currentImage;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  final PainterController _controller = PainterController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.transparent;
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
          "DRAW",
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
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  currentImage = value.currentImage;
                  return Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Image.memory(value.currentImage!),
                        Positioned.fill(
                            child: Painter(_controller)
                        )
                      ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.deepPurple,
                      size: _controller.thickness + 2,
                    ),
                    Expanded(
                      child: slider(
                        value: _controller.thickness,
                        onChanged: (value){
                          setState(() {
                            _controller.thickness = value;
                          });
                        }
                      ),
                    ),
                  ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomBarItem(
                    'assets/icons/draw_icon.png',
                    33.0.w,
                    onPress: () {
                      setState(() {
                        _controller.eraseMode = false;
                      });
                    }
                ),
                _bottomBarItem(
                    'assets/icons/erase_icon.png',
                    33.0.w,
                    onPress: () {
                      setState(() {
                        _controller.eraseMode = true;
                      });
                    }
                ),
                _bottomBarItem(
                    'assets/icons/color_palette_icon.png',
                    33.0.w,
                    onPress: () {
                      AppColorPicker().show(
                          context,
                          backgroundColor: _controller.drawColor,
                          onPick: (color){
                            setState(() {
                              _controller.drawColor = color;
                            });
                          }
                      );
                    }
                ),
                _bottomBarItem(
                    'assets/icons/color_dropper_icon.png',
                    33.0.w,
                    onPress: () {
                      PixelColorImage().show(
                          context,
                          backgroundColor: _controller.drawColor,
                          image: currentImage,
                          onPick: (color){
                            setState(() {
                              _controller.drawColor = color;
                            });
                          }
                      );
                    }
                ),
                _bottomBarItem(
                    'assets/icons/undo_icon_draw_screen.png',
                    33.0.w,
                    onPress: () {
                      _controller.undo();
                    }
                ),
                _bottomBarItem(
                    'assets/icons/bin_icon_draw_screen.png',
                    33.0.w,
                    onPress: () {
                      _controller.clear();
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(String icon, double width, {required onPress}){
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
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged}){
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 20,
      min: 1,
      onChanged: onChanged
    );
  }
}
