import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import '../helper/stickers.dart';
import '../providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({Key? key}) : super(key: key);

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();

  int index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen:false);
    controller.borderColor = Palette.titleText;
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
          "STICKER",
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
              Uint8List? image = await controller.saveAsUint8List();
              imageProvider.changeImage(image!);
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
              return LindiStickerWidget(
                controller: controller,
                child: Image.memory(value.currentImage!),
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
                Container(
                    width: double.infinity,
                    height: 54.h,
                    color: Palette.appBarBackground,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Stickers().list()[index].length,
                        itemBuilder: (BuildContext context, int idx) {
                          String sticker = Stickers().list()[index][idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 54.w,
                                    height: 54.h,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                controller.addWidget(
                                                    Image.asset(sticker, width: 100.w,)
                                                );
                                              });
                                            },
                                            child: Image.asset(
                                                sticker,
                                                fit: BoxFit.contain,
                                                height: 33.h,
                                                width: 33.w),
                                            )
                                        )
                                    )
                              ],
                            ),
                          );
                        }
                    ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(int i = 0; i < Stickers().list().length; i++)
                      _bottomItem(
                          i,
                          Stickers().list()[i][0],
                          onPress: () {
                            setState(() {
                              index = i;
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

  Widget _bottomItem(int idx, String icon, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: index == idx ? Palette.titleText : Colors.transparent,
              height: 2,
              width: 16.5.w
            ),
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
