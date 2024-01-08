import 'package:csslib/parser.dart' as css;
import 'package:pheasant_assets/src/sass/logger.dart';
import '../assets.dart';
import 'package:sass/sass.dart' as sass;

String compileCss(PheasantStyle pheasantStyle, String cssString) {
  var cssErrors = <css.Message>[];

  if (pheasantStyle.syntax == 'css') {
    css.compile(
      cssString, 
      errors: cssErrors
    );
    if (cssErrors.isNotEmpty) {
      cssErrors.forEach(print);
      return '';
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
      print(exception.message);
      return '';
    }
  }
}

String compileSassFile(PheasantStyle pheasantStyle, String sassPath) {
  try {
    final cssData = sass.compileToResult(
      sassPath,
      logger: sassLogger
    );
    return cssData.css;
  } on sass.SassException catch (exception) {
    print(exception.message);
    return '';
  }
}
