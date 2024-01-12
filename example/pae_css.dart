import 'package:pheasant_assets/pheasant_assets.dart';

void main() {
  PheasantStyle myStyle = getStyleInput('<style src="foo.css"></style>');
  print(scopeComponents(myStyle, isDev: true).css);
  
}