import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';

void main() {
  String cssString = '''
    body {
      font-family: 'Arial', sans-serif;
      color: #333;
    }

    .container {
      width: 100%;
      margin: 0 auto;
    }

    @media (max-width: 768px) {
      .container {
        width: 100%;
      }
    }

    .button:hover {
      background-color: #2980b9;
    }
''';
  var component = css.compile(cssString);
  var visitor = Visitor();
}