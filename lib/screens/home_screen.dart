import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.h),
        child: AppBar(
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
            "IMAGE WIZARD",
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
              onPressed: () {

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
      body: Center(
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
                  15.w,
                  23.w,
                  onPress: () {
                    Navigator.of(context).pushReplacementNamed('/crop');
                  }
                ),
                _bottomItem(
                    'assets/icons/adjust_icon.jpeg',
                    'Adjust',
                    39.0.w,
                    23.w,
                    23.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/adjust');
                    }
                ),
                _bottomItem(
                    'assets/icons/filters_icon.jpeg',
                    'Filters',
                    33.0.w,
                    23.w,
                    23.w,
                    onPress: () {
                      Navigator.of(context).pushReplacementNamed('/filter');
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(String icon, String title, double width, double l, double r, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.only(left: l, right: r),
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

