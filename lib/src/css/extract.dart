// import 'dart:io';
import 'package:pheasant_assets/src/assets.dart';
import 'package:pheasant_assets/src/compile/compile.dart';

String css(PheasantStyle pheasantStyle) {
  String styleData = pheasantStyle.data ?? "";
  if (pheasantStyle.data == null) {
    if (pheasantStyle.src == null) {
      return '';
    } else {
      styleData = compileSassFile(pheasantStyle, pheasantStyle.src!);
      return styleData;
    }
  }
  return compileCss(pheasantStyle, styleData);
}
