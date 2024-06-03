import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photoeditorapp/widgets/filtered_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../helper/convolution_filters.dart';
import '../model/convolution_filter.dart';
import '../providers/app_image_provider.dart';
import '../themes/font.dart';
import '../themes/palette.dart';
import 'package:image/image.dart' as img;

class ConvolutionFilterScreen extends StatefulWidget {
  const ConvolutionFilterScreen({Key? key}) : super(key: key);

  @override
  State<ConvolutionFilterScreen> createState() => _FilterScreenState();
}


class _FilterScreenState extends State<ConvolutionFilterScreen> {

  late ConvolutionFilter currentFilter;
  late List<ConvolutionFilter> filters;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = ConvolutionFilters().list();
    currentFilter = filters[0];
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
          " CONVOLUTION",
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
              return Screenshot(
                controller: screenshotController,
                child: FilteredImageWidget(
                  filter: currentFilter.filter,
                  image: img.decodeImage(value.currentImage!)!,
                  successBuilder: (imageBytes) =>
                      Image.memory(imageBytes as Uint8List),
                  errorBuilder: () => Container(color: Colors.white,),
                  loadingBuilder: () => Container(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
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
        height: 74.h,
        child: SafeArea(
            child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (BuildContext context, int index) {
                        ConvolutionFilter filter = filters[index];
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
                                              currentFilter = filter;
                                            });
                                          },
                                          child:FilteredImageWidget(
                                            filter: filter.filter,
                                            image: img.decodeImage(value.currentImage!)!,
                                            successBuilder: (imageBytes) =>
                                                Image.memory(imageBytes as Uint8List),
                                            errorBuilder: () => Container(color: Colors.white,),
                                            loadingBuilder: () => Container(
                                              child: const Center(child: CircularProgressIndicator()),
                                            ),
                                          )
                                      )
                                  )
                              ),
                              Text(filter.filterName,
                                style: TextStyle(
                                    color: Palette.whiteText,
                                    fontSize: Font.font10.sp,
                                    fontFamily: Font.allfonts
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
            )
        ),
      ),
    );
  }
}