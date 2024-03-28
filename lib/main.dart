import 'package:flutter/material.dart';
import 'package:photoeditorapp/providers/app_image_provider.dart';
import 'package:photoeditorapp/screens/adjust_screen.dart';
import 'package:photoeditorapp/screens/crop_rotate_screen.dart';
import 'package:photoeditorapp/screens/filter_screen.dart';
import 'package:photoeditorapp/screens/start_screen.dart';
import 'package:photoeditorapp/themes/palette.dart';
import 'package:provider/provider.dart';
import 'package:photoeditorapp/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider())
      ],
      child:const MyApp())
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(406, 785),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_ , child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Photo Editor',
            theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              color: Palette.appBarBackground,
              centerTitle: true,
              elevation: 0
            ),
            sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always
            )
            ),
            routes: <String, WidgetBuilder>{
            '/': (_) => const StartScreen(),
            '/home': (_) => const HomeScreen(),
            '/crop': (_) => const CropScreen(),
            '/adjust': (_) => const AdjustScreen(),
            '/filter': (_) => const FilterScreen()
            },
            initialRoute: '/',
          );
        },
    );
  }
}

