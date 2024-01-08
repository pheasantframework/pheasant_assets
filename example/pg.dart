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

    button[type] {
      background-color: red;
    }

    .foo {
      color: red;
      left: 20px;
      top: 20px;
      width: 100px;
      height: 200px;
    }

    #div {
      color: #00F578;
      border-color: #878787;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
      }
      to {
        opacity: 1;
      }
    }

    .fade-in-element {
      animation: fadeIn 1s ease;
    }
  ''';
  print(addScopeToCss(cssString, 'ffff'));
  final RegExp keyframeRegExp = RegExp(r'@keyframes\s+([\w-]+)\s*{([^}]+)}', multiLine: true);
  print(keyframeRegExp.allMatches(cssString).map((e) => [e[0], e[1], e[2]]));
}

// String renderScopedCss(String cssString, String uniqueIdentifier) {
//   final lines = cssString.split('\n');
//   final resultLines = <String>[];

//   for (final line in lines) {
//     final trimmedLine = line.trim();
//     if (trimmedLine.isNotEmpty) {
//       // Check if it's a selector line
//       if (trimmedLine.endsWith('{')) {
//         final selector = trimmedLine.substring(0, trimmedLine.length - 1).trim();
//         final scopedSelector = '$selector[data-$uniqueIdentifier]';
//         resultLines.add('$scopedSelector {');
//       } else {
//         resultLines.add(line);
//       }
//     }
//   }

//   return resultLines.join('\n');
// }

// String scopedCss(String cssString, String uniqueIdentifier) {
//   RegExp selectorRegExp = RegExp(r'([^{]+)\s*{', multiLine: true);

//   String resultCss = cssString.replaceAllMapped(
//     selectorRegExp,
//     (match) {
//       String selector = match.group(1)!.trim();
//       String scopedSelector = '$selector[data-$uniqueIdentifier]';
//       return '$scopedSelector {';
//     },
//   );

//   return resultCss;
// }


String addScopeToCss(String cssString, String scopeAttribute) {
  RegExp cssSelectorRegExp = RegExp(r'(?:.|#)?[a-zA-Z+][\w-]*(?:\[[a-zA-Z+][\w-]*\])?\s+(?:\{)');

  var data = cssString.replaceAllMapped(
    cssSelectorRegExp, 
    (match) {
      String data = (match[0] ?? '')
      .replaceAll(':', '[$scopeAttribute]:');
      if (!data.contains(scopeAttribute)) {
        data = (match[0] ?? '')
      .replaceAllMapped(RegExp(r'\[[a-zA-Z+][\w-]*\]'), (mat) {
        return ('[$scopeAttribute]${mat[0]}');
      });
      } 
      if (!data.contains(scopeAttribute)) {
        data = (match[0] ?? '')
      .replaceAll(' {', '[$scopeAttribute] {');
      }
      return data;
    }
  );
  return data;
}

Map<String, List<Map<String, String>>> extractKeyframes(String css) {
  // Regular expression to match @keyframes and its content
  RegExp keyframesRegex = RegExp(r'@keyframes\s+(\w+)\s*{([^}]+)}');

  // Match @keyframes part in the CSS string
  Iterable<RegExpMatch> matches = keyframesRegex.allMatches(css);

  // Map to store extracted keyframes data
  Map<String, List<Map<String, String>>> keyframesData = {};

  // Process each match
  for (RegExpMatch match in matches) {
    String animationName = match.group(1) ?? '';
    String keyframesContent = match.group(2) ?? '';

    // Regular expression to match individual keyframes
    RegExp keyframeRegex = RegExp(r'(\d+%)\s*{([^}]+)}');

    // Match individual keyframes within the @keyframes content
    Iterable<RegExpMatch> keyframeMatches = keyframeRegex.allMatches(keyframesContent);

    // List to store keyframes data
    List<Map<String, String>> keyframesList = [];

    // Process each keyframe match
    for (RegExpMatch keyframeMatch in keyframeMatches) {
      String percentage = keyframeMatch.group(1) ?? '';
      String properties = keyframeMatch.group(2) ?? '';

      // Add keyframe data to the list
      keyframesList.add({'percentage': percentage, 'properties': properties.trim()});
    }

    // Add animation data to the map
    keyframesData[animationName] = keyframesList;
  }

  return keyframesData;
}

String removeKeyframes(String css) {
  // Regular expression to match @keyframes and its content
  RegExp keyframesRegex = RegExp(r'@keyframes.*?}');

  // Remove @keyframes and its content from the CSS string
  String modifiedCss = css.replaceAll(keyframesRegex, '');

  return modifiedCss;
}

String scopeCss(String cssString) {
  RegExp cssSelectorRegExp = RegExp(r'(?:.|#)?[a-zA-Z+][\w-]*(?:\[[a-zA-Z+][\w-]*\])?\s+(?:\{)');
  
  List<Match> matches = cssSelectorRegExp.allMatches(cssString).toList();

  for (Match match in matches) {
    print(match[0]);
  }
  
  return "";
}

// class _ScopeCssVisitor extends css_visitor.CssPrinter {
//   final String scopeAttribute;

//   _ScopeCssVisitor(this.scopeAttribute);

//   @override
//   void visitClassSelector(css_visitor.ClassSelector node) {
    
//   }
// }
