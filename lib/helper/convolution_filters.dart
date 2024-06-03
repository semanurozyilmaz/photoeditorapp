import 'package:photofilters/filters/subfilters.dart';
import 'package:photofilters/utils/convolution_kernels.dart';
import '../model/convolution_filter.dart';
import 'package:photofilters/filters/image_filters.dart';

class ConvolutionFilters{
  List <ConvolutionFilter> list(){
    return <ConvolutionFilter>[
      ConvolutionFilter(
        'Identity',
        ImageFilter(name: "Identity")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(identityKernel)),
      ),
      ConvolutionFilter(
        'Edge Detection',
        ImageFilter(name: "Edge Detection Hard")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(edgeDetectionHardKernel)),
      ),
      ConvolutionFilter(
        'Sharpen',
        ImageFilter(name: "Sharpen")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(sharpenKernel)),
      ),
      ConvolutionFilter(
        'Blur',
        ImageFilter(name: "Blur")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(blurKernel)),
      ),
      ConvolutionFilter(
        'Low Pass',
        ImageFilter(name: "Low Pass 3x3")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(lowPass3x3Kernel)),
      ),
      ConvolutionFilter(
        'High Pass',
        ImageFilter(name: "High Pass 3x3")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(highPass3x3Kernel)),
      ),
      ConvolutionFilter(
        'Mean',
        ImageFilter(name: "Mean 3x3")
          ..addSubFilter(ConvolutionSubFilter.fromKernel(mean3x3Kernel)),
      ),

    ];
  }
}