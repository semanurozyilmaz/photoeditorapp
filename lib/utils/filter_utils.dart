import 'package:flutter/foundation.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:image/image.dart' as img;

class FilterUtils {
  static final Map<String, List<int>> _cacheFilter = {};

  static void clearCache() => _cacheFilter.clear();

  static void saveCachedFilter(Filter filter, List<int> imageBytes) {
    _cacheFilter[filter.name] = imageBytes;
  }

  static List<int>? getCachedFilter(Filter filter) {
    return _cacheFilter[filter.name];
  }

  static Future<List<int>> applyFilter(img.Image image, Filter filter) {
    return compute(
      _applyFilterInternal,
      <String, dynamic>{
        'filter': filter,
        'image': image,
        'width': image.width,
        'height': image.height,
      },
    );
  }

  static List<int> _applyFilterInternal(Map<String, dynamic> params) {
    Filter filter = params["filter"];
    img.Image image = params["image"];
    int width = params["width"];
    int height = params["height"];

    final bytes = image.getBytes();
    filter.apply(bytes, width, height);

    final newImage = img.Image.fromBytes(width, height, bytes);
    return img.encodeJpg(newImage);
  }
}