import 'package:pheasant_assets/pheasant_assets.dart';

void main() {
  PheasantStyle myStyle = getStyleInput('<style src="foo.css"></style>');
  PheasantStyleScoped scopedStyle = scopeComponents(myStyle, isDev: true);
  print("CSS Data: ${scopedStyle.css}");
  print("CSS Scoping ID: ${scopedStyle.id}");
}