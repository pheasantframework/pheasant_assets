import 'package:pheasant_assets/src/css/id_scope.dart';

enum StyleScope {local, shared, global}

class PheasantStyle {
  static RegExp styleRegex = RegExp(
    r'<style\s*' // Match the opening tag '<style' and one or more whitespaces
    r'(?:src="([^"]*)")?\s*' // Optional src attribute and its value
    r'(?:syntax="([^"]*)")?\s*' // Optional syntax attribute and its value
    r'(?:(local|global))?' // Optional local attribute
    r'>', // Match the closing angle bracket '>'
  );

  final String? data;
  final String? src;
  final String syntax;
  final StyleScope scope;

  const PheasantStyle({this.src, this.data, this.scope = StyleScope.local}) : syntax = 'css';
  const PheasantStyle.sassEnabled({required this.syntax, this.src, this.data, this.scope = StyleScope.local});

  PheasantStyle.nc(this.data, this.src, this.syntax, this.scope);

  factory PheasantStyle.scoped({
    String data = '',
    String src = '',
    String syntax = 'css',
    StyleScope scope = StyleScope.local,
    String css = ''
  }) {
    PheasantStyle pheasantStyle = PheasantStyle.sassEnabled(data: data, src: src, syntax: syntax, scope: scope);
    return PheasantStyleScoped(id: makeId(pheasantStyle), pheasantStyle: pheasantStyle, scoped: scope == StyleScope.local);
  } 
}

class PheasantStyleScoped extends PheasantStyle {
  final String id;
  final bool scoped;

  String css;

  PheasantStyleScoped({required this.id, required this.scoped, required PheasantStyle pheasantStyle, this.css = ''})
  : super(data: pheasantStyle.data, scope: pheasantStyle.scope, src: pheasantStyle.src);
}