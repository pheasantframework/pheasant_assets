import '../css/extract.dart';
import '../css/id_scope.dart';

import '../assets.dart';
import '../sass/logger.dart';

import 'package:sass/sass.dart' as sass;


PheasantStyleScoped scopeComponents(PheasantStyle pheasantStyle, {bool isDev = false, String appPath = 'lib'}) {
  String cssData = css(pheasantStyle, dev: isDev, appPath: appPath);
  String specialid = makeId(pheasantStyle);

  String scopableCssData = '''
$specialid {
  $cssData
}
''';

  String scopedCssData = sass.compileStringToResult(
    scopableCssData,
    syntax: sass.Syntax.scss,
    logger: sassLogger
  ).css;
  // PheasantStyle newStyle = pheasantStyle.syntax != 'css' ? PheasantStyle.sassEnabled(syntax: pheasantStyle.syntax) : PheasantStyle();

  return PheasantStyleScoped(
    id: makeId(pheasantStyle).replaceFirst('.', ''), 
    pheasantStyle: pheasantStyle,
    css: pheasantStyle.scope == StyleScope.global ? cssData : scopedCssData,
    scoped: pheasantStyle.scope == StyleScope.local
  );
}
