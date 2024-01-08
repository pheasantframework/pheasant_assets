import 'package:pheasant_assets/src/assets.dart';

String makeId(PheasantStyle pheasantStyle) {
  String pheasantPrefix = "phs-";
  String specialid = ".$pheasantPrefix${pheasantStyle.hashCode}";
  return specialid;
}
