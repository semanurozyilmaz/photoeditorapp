import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;


class ConvolutionWidget extends StatelessWidget {
  final img.Image src;
  final List<num> filter;
  final num div;
  final num offset;
  final num amount;
  final img.Image? mask;
  final img.Channel maskChannel;

  const ConvolutionWidget({super.key, 
    required this.src,
    required this.filter,
    this.div = 1.0,
    this.offset = 0.0,
    this.amount = 1,
    this.mask,
    this.maskChannel = img.Channel.luminance,
  });

  @override
  Widget build(BuildContext context) {
      final image = img.convolution(src, filter);
      return Image.memory(image.getBytes());

  }
}