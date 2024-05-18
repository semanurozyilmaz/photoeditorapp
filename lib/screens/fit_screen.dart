import 'dart:io';
import 'dart:typed_data';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoeditorapp/helper/app_color_picker.dart';
import 'package:photoeditorapp/helper/app_image_picker.dart';
import 'package:photoeditorapp/helper/pixel_color_image.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../helper/textures.dart';
import '../providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import '../model/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({Key? key}) : super(key: key);

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  late t.Texture currentTexture;
  late List<t.Texture> textures;

  Uint8List? mainImage;
  Uint8List? backgroundImage;
  Color backgroundColor = Colors.white;

  int x = 1;
  int y = 1;

  double blur = 0;

  bool showRatio = true;
  bool showColor = false;
  bool showImage = false;
  bool showTexture = false;

  bool showColorBackground = true;
  bool showImageBackground = false;
  bool showTextureBackground = false;

  @override
  void initState() {
    textures = Textures().list();
    currentTexture = textures[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  showActiveWidget({r,c,i,t}){
    showRatio = r!= null ? true : false;
    showColor = c!= null ? true : false;
    showImage = i!= null ? true : false;
    showTexture = t!= null ? true : false;
    setState(() {});
  }

  showBackgroundWidget({c,i,t}){
    showColorBackground = c!= null ? true : false;
    showImageBackground = i!= null ? true : false;
    showTextureBackground = t!= null ? true : false;
    setState(() {});
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
          "FIT",
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
              mainImage = value.currentImage;
              backgroundImage ??= value.currentImage!;
              return AspectRatio(
                aspectRatio: x/y,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      if(showColorBackground)
                      Container(
                        color: backgroundColor,
                      ),
                      if(showImageBackground)
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(backgroundImage!)
                          )
                        ),
                      ).blurred(
                        colorOpacity: 0,
                        blur: blur
                      ),
                      if(showTextureBackground)
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(currentTexture.path!)
                              )
                          ),
                        ).blurred(
                            colorOpacity: 0,
                            blur: blur
                        ),
                      Center(child: Image.memory(value.currentImage!)),
                    ],
                  )
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
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 54.h,
                color: Palette.appBarBackground,
                child: Stack(
                  children: [
                    if(showRatio)
                    ratioWidget(),
                    if(showColor)
                      colorWidget(),
                    if(showImage)
                      imageWidget(),
                    if(showTexture)
                      textureWidget(),
                  ],
                )
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _bottomItem(
                        'assets/icons/ratio_icon_fit_screen.png',
                        'Ratio',
                        33.0.w,
                        onPress: () {
                          showActiveWidget(r: true);
                        }
                    ),
                    _bottomItem(
                        'assets/icons/color_palette_icon.png',
                        'Color',
                        33.0.w,
                        onPress: () {
                          showBackgroundWidget(c: true);
                          showActiveWidget(c: true);
                        }
                    ),
                    _bottomItem(
                        'assets/icons/image_icon_fit_screen.png',
                        'Image',
                        33.0.w,
                        onPress: () {
                          showBackgroundWidget(i: true);
                          showActiveWidget(i: true);
                        }
                    ),
                    _bottomItem(
                        'assets/icons/texture_icon_fit_screen.png',
                        'Texture',
                        33.0.w,
                        onPress: () {
                          showBackgroundWidget(t: true);
                          showActiveWidget(t: true);
                        }
                    ),
                  ],
                ),
              ),
            ]
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

  Widget ratioWidget(){
   return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    x = 1;
                    y = 1;
                  });
                },
                child: Text('1:1',
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font12.sp,
                        fontFamily: Font.allfonts
                    )
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    x = 1;
                    y = 2;
                  });
                },
                child: Text('1:2',
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font12.sp,
                        fontFamily: Font.allfonts
                    )
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    x = 2;
                    y = 1;
                  });
                },
                child: Text('2:1',
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font12.sp,
                        fontFamily: Font.allfonts
                    )
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    x = 4;
                    y = 3;
                  });
                },
                child: Text('4:3',
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font12.sp,
                        fontFamily: Font.allfonts
                    )
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    x = 16;
                    y = 9;
                  });
                },
                child: Text('16:9',
                    style: TextStyle(
                        color: Palette.whiteText,
                        fontSize: Font.font12.sp,
                        fontFamily: Font.allfonts
                    )
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget(){
    return Container(
      color: Palette.appBarBackground,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              InkWell(
              onTap: (){
                AppImagePicker(source: ImageSource.gallery)
                    .pick(onPick: (File? image) async{
                  backgroundImage = await image!.readAsBytes();
                  setState(() {});
                });
              },
                child: Image.asset(
                    'assets/icons/image_icon_fit_screen.png',
                    fit: BoxFit.contain,
                    height: 33.h,
                    width: 33.w
                ),
              ),
            Slider(
              label: blur.toStringAsFixed(2),
              value:blur,
              max: 100,
              min: 0,
              onChanged: (value){
                setState(() {
                  blur = value;
                });
              },
            )
          ],
        )
      )
    );
  }

  Widget colorWidget(){
    return Container(
        color: Palette.appBarBackground,
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    AppColorPicker().show(
                      context,
                      backgroundColor: backgroundColor,
                      onPick: (color){
                        setState(() {
                          backgroundColor = color;
                        });
                      }
                    );
                  },
                  child: Image.asset(
                      'assets/icons/color_palette_icon.png',
                      fit: BoxFit.contain,
                      height: 33.h,
                      width: 33.w
                  ),
                ),
                InkWell(
                  onTap: (){
                    PixelColorImage().show(
                      context,
                      backgroundColor: backgroundColor,
                      image: mainImage,
                      onPick: (color){
                        setState(() {
                          backgroundColor = color;
                        });
                      }
                    );
                  },
                  child: Image.asset(
                      'assets/icons/color_dropper_icon.png',
                      fit: BoxFit.contain,
                      height: 33.h,
                      width: 33.w
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget textureWidget(){
    return Container(
      color: Palette.appBarBackground,
      child: SafeArea(
          child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: textures.length,
                    itemBuilder: (BuildContext context, int index) {
                      t.Texture texture = textures[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 37.w,
                                height: 37.h,
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentTexture = texture;
                                          });
                                        },
                                        child: Image.asset(texture.path!)
                                    )
                                )
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
          )
      ),
    );
  }
}
