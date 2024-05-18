import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photoeditorapp/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:photoeditorapp/themes/palette.dart';
import '../themes/font.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  late AppImageProvider appImageProvider;

  @override
  void initState(){
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  _savePhoto() async {
    final result = await ImageGallerySaver.saveImage(
      appImageProvider.currentImage!,
      quality: 100,
      name: "${DateTime.now().millisecondsSinceEpoch}"
    );
    if(!mounted) return false;
    if(result['isSuccess']){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Image saved to Gallery!")
        )
      );
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong!")
          )
      );
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.h),
        child: AppBar(
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
          title: Center(
            child: Text(
              "IMAGE WIZARD",
              style: TextStyle(
                  color: Palette.titleText,
                  fontSize: Font.font24.sp,
                  fontFamily: Font.allfonts
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent),
              onPressed: () {
                _savePhoto();
              },
              child: Image.asset(
                'assets/icons/download_button.png',
                fit: BoxFit.contain,
                height: 33.h,
                width: 33.w,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Palette.background,
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child){
                if(value.currentImage!=null){
                  return Image.memory(
                      value.currentImage!,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Consumer<AppImageProvider>(
              builder: (context, value, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.appBarBackground,
                          elevation: 0.7),
                      onPressed: () {
                        appImageProvider.undo();
                      },
                      child: Image.asset(
                        value.canUndo
                            ? 'assets/icons/undo_icon.png'
                            : 'assets/icons/undo_grey_icon.png',
                        fit: BoxFit.contain,
                        height: 22.h,
                        width: 22.w,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.appBarBackground,
                          elevation: 0.7),
                      onPressed: () {
                        appImageProvider.redo();
                      },
                      child: Image.asset(
                        value.canRedo
                            ? 'assets/icons/redo_icon.png'
                            : 'assets/icons/redo_grey_icon.png',
                        fit: BoxFit.contain,
                        height: 22.h,
                        width: 22.w,
                      ),
                    ),
                  ],
                );
              }
            )
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
                  'assets/icons/crop_rotate_icon.png',
                  'Crop/Rotate',
                  33.0.w,
                  onPress: () {
                    Navigator.of(context).pushReplacementNamed('/crop');
                  }
                ),
                _bottomItem(
                    'assets/icons/adjust_icon.jpeg',
                    'Adjust',
                    39.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/adjust');
                    }
                ),
                _bottomItem(
                    'assets/icons/filters_icon.jpeg',
                    'Filters',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/filter');
                    }
                ),
                _bottomItem(
                    'assets/icons/convolution_filters_icon.png',
                    'Convolution',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/convolution');
                    }
                ),
                _bottomItem(
                    'assets/icons/fit_icon.png',
                    'Fit',
                    35.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/fit');
                    }
                ),
                _bottomItem(
                    'assets/icons/sticker_icon.png',
                    'Sticker',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/sticker');
                    }
                ),
                _bottomItem(
                    'assets/icons/text_icon.png',
                    'Text',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/text');
                    }
                ),
                _bottomItem(
                    'assets/icons/draw_icon.png',
                    'Draw',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/draw');
                    }
                ),
                _bottomItem(
                    'assets/icons/mask_icon.png',
                    'Mask',
                    33.0.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/mask');
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
        padding: EdgeInsets.symmetric(horizontal: 15.w),
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
}

