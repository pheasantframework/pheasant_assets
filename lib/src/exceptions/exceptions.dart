import 'package:pheasant_meta/pheasant_meta.dart';

/// Pheasant Style Implementation of [PheasantException] for use in this package
class PheasantStyleException extends PheasantException {
  /// Default Constructor
  PheasantStyleException(super.message);

  @override
  String toString() {
    return message;
  }
}
