import 'dart:io';

import 'package:csslib/parser.dart' as css;
import 'package:sass/sass.dart' as sass;
import 'package:pheasant_meta/pheasant_meta.dart';

enum StyleScope {local, shared, global}

class PheasantStyleException extends PheasantException {
  PheasantStyleException(super.message);
}

class PheasantStyleError extends PheasantError {}

class PheasantStyle {
  final String? data;
  final String? src;
  final String syntax;
  final StyleScope scope;

  const PheasantStyle({this.src, this.data, this.scope = StyleScope.local}) : syntax = 'css';
  const PheasantStyle.sassEnabled({required this.syntax, this.src, this.data, this.scope = StyleScope.local});

  String get css {
    String styleData = data ?? "";
    if (data == null) {
      if (src == null) {
        throw PheasantStyleException('"data" field and "src" field cannot be blank at the same time');
      } else {
        styleData = File(src!).readAsStringSync();
      }
    }
    return compileCss(this, styleData);
  }
}

String compileCss(PheasantStyle pheasantStyle, String cssString) {
  var cssErrors = <css.Message>[];
  var sassErrorLogger = sass.Logger.stderr(color: true);

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
        logger: sassErrorLogger
      );
      return cssData.css;
    } on sass.SassException catch (exception) {
      print(exception.message);
      return '';
    }
  }
}

PheasantStyle getStyleInput(String style) {
  RegExp regex = RegExp(
    r'<style\s*' // Match the opening tag '<style' and one or more whitespaces
    r'(?:src="([^"]*)")?\s*' // Optional src attribute and its value
    r'(?:syntax="([^"]*)")?\s*' // Optional syntax attribute and its value
    r'(?:(local|global))?' // Optional local attribute
    r'>', // Match the closing angle bracket '>'
  );
  Match mainMatch = regex.allMatches(style).first;
  String data = style.replaceFirst(regex, '').replaceFirst('</style>', '').trim();
  return PheasantStyle(
    // syntax: mainMatch[2] ?? 'css',
    src: mainMatch[1],
    data: data.isEmpty ? null : data,
    scope: mainMatch[3] == 'global' ? StyleScope.global : StyleScope.local
  );
}

PheasantStyleScoped scopeComponents(PheasantStyle pheasantStyle) {
  // TODO: Create scopeComponents Function
  /// 1. Get component names
  /// 2. Attach random ID using the pheasantstyle hash code
  /// 3. Create a map, mapping the original names to the final names
  PheasantStyle newStyle = pheasantStyle.syntax != 'css' ? PheasantStyle.sassEnabled(syntax: pheasantStyle.syntax) : PheasantStyle();
  Map<String, String> changes = <String, String>{};
  return PheasantStyleScoped(changes: changes, pheasantStyle: pheasantStyle);
}

class PheasantStyleScoped extends PheasantStyle {
  final Map<String, String> changes;

  PheasantStyleScoped({required this.changes, required PheasantStyle pheasantStyle})
  : super(data: pheasantStyle.data, scope: pheasantStyle.scope, src: pheasantStyle.src);

  PheasantStyleScoped.sassEnabled({required this.changes, required PheasantStyle pheasantStyle})
  : super.sassEnabled(syntax: pheasantStyle.syntax, data: pheasantStyle.data, scope: pheasantStyle.scope, src: pheasantStyle.src);
}