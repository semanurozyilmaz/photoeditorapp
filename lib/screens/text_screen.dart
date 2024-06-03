import 'dart:typed_data';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:text_editor/text_editor.dart';
import '../providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import '../helper/fonts.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({Key? key}) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();

  bool showEditor = false;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen:false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              "TEXT",
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
            width: double.infinity,
            height: 74.h,
            child: Center(
              child: TextButton(
                onPressed: (){
                  setState(() {
                    showEditor = true;
                  });
                },
                child: Text(
                    "+ Add Text",
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font24.sp,
                        fontFamily: Font.allfonts
                    ))
              ),
            )
          ),
        ),
        if(showEditor)
        Scaffold(
          backgroundColor: Palette.addTextBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color:Colors.white),
                  minFontSize: 10,
                  maxFontSize: 70,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if(text.isNotEmpty){
                        controller.addWidget(
                            Text(text,
                              textAlign: align,
                              style: style)
                        );
                      }
                    });
                  },
                ),
              ),
            )
        )
      ],
    );
  }
}
