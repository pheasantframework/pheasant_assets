import 'dart:developer';
import 'dart:io';

import 'package:csslib/parser.dart' as css;
import 'package:path/path.dart';
import 'package:sass/sass.dart' as sass;

import '../exceptions/exceptions.dart';
import '../sass/logger.dart';
import '../assets.dart';

/// Function used to compile css.
/// This function is the second step after the `css()` function, when it comes to compiling css. 
/// 
/// Here, the [PheasantStyle] object only serves the purpose of denoting the configuration (`syntax` and so on) of the compiler function.
/// 
/// The [cssString] represents the string to be compiled. 
/// 
/// Returns the compiled css as a String, throws an error if it didn't compile.
String compileCss(PheasantStyle pheasantStyle, String cssString) {
  var cssErrors = <css.Message>[];
  if (!['css', 'sass', 'scss'].contains(pheasantStyle.syntax)) {
    throw PheasantStyleException('Syntax is invalid: ${pheasantStyle.syntax}');
  }

  if (pheasantStyle.syntax == 'css') {
    css.compile(
      cssString, 
      errors: cssErrors,
    );
    if (cssErrors.isNotEmpty) {
      cssErrors.forEach((element) {
        log("Error: ${element.message}");
        log("Error Description: ${element.describe}");
      });
      throw PheasantStyleException("Error(s) Occured while Compiling CSS: ${cssErrors.map((e) => e.message)}\n $pheasantStyle");
    } else {
      return cssString;
    }
  } else {
    try {
      final cssData = sass.compileStringToResult(
        cssString, 
        syntax: pheasantStyle.syntax == 'scss' ? sass.Syntax.scss : sass.Syntax.sass,
        logger: sassLogger
      );
      return cssData.css;
    } on sass.SassException catch (exception) {
      throw PheasantStyleException("Error occured while Compiling ${pheasantStyle.syntax == 'scss' ? "SCSS" : "SASS"} : ${exception.message}");
    }
  }
}

String compileSassFile(PheasantStyle pheasantStyle, String sassPath, {String componentDirPath = 'lib', String? devDirPath}) {
  String absPath = join(Directory.current.path, (devDirPath ?? componentDirPath), sassPath);
  if (!['css', 'sass', 'scss'].contains(pheasantStyle.syntax)) {
    throw PheasantStyleException('Syntax is invalid: ${pheasantStyle.syntax}');
  }

  try {
    final cssData = sass.compileToResult(
      absPath,
      logger: sassLogger
    );
    return cssData.css;
  } on sass.SassException catch (exception) {
    throw PheasantStyleException("Error occured while Compiling ${pheasantStyle.syntax == 'scss' ? "SCSS" : (pheasantStyle.syntax == 'sass' ? "SASS" : "CSS")} : ${exception.message}");
  }
}
