import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageUtils {
  static Future<void> svgPrecacheImage() async {
    for (int i = 1; i <= 114; i++) {
      var loader = SvgAssetLoader(
          'assets/svgs/surah_names/Surah_${i}_of_114_(modified).svg');
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
    for (int i = 0; i <= 4; i++) {
      var loader = SvgAssetLoader('assets/svgs/sign$i.svg');
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
    // todo: implement one for themes
    debugPrint('assets loaded successfully');
  }
}
