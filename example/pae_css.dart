import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';
import 'package:pheasant_assets/pheasant_assets.dart';

void main() {
  // Your CSS content
  String cssContent = '''
    @import "support/at-charset-019.css";
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

    button[type] { background-color: red; }

    .foo { 
      color: red; left: 20px; top: 20px; width: 100px; height:200px
    }

    #div {
      color : #00F578; border-color: #878787;
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

  // Parse the CSS content
  StyleSheet stylesheet = css.parse(cssContent);

  // Create a visitor to extract information
  Visitor visitor = _Visitor();

  // StyleSheet newStylesheet = css.compile(cssContent);

  stylesheet.visit(visitor);

  List<RuleSet> ruleSets = (visitor as _Visitor).ruleSets;

  for (RuleSet ruleSet in ruleSets) {
    print('Selector: ${ruleSet.selectorGroup?.selectors.first.simpleSelectorSequences.first.simpleSelector.name}');
    print('Selector Items: ${ruleSet.selectorGroup?.selectors.first.simpleSelectorSequences}');
    print('Selector Full: ${ruleSet.selectorGroup?.span?.text}');
    print('Declarations : ${ruleSet.declarationGroup.declarations.map((e) => e.span?.text)}');
    // ruleSet.declarationGroup.declarations.forEach((declaration) {
    //   print('  Property: ${declaration.span}, Value: ${declaration.toString()}');
    // });
    print('-----');
  }
  print('-----');
  for (MediaDirective mediaDirective in stylesheet.topLevels.whereType<MediaDirective>()) {
    print('Directive Restriction: ${mediaDirective.mediaQueries.first.span.text}');
    print('Directive Feature: ${mediaDirective.mediaQueries.first.expressions.first.mediaFeature}');
    print('Directive Value: ${mediaDirective.mediaQueries.first.expressions.first.exprs.expressions}'); // Addable
    print('Directive: ${(mediaDirective.rules.first as RuleSet)}');
    print('-----');
  }
  print('-----');
  // ImportDirective

  for (KeyFrameDirective keyframe in stylesheet.topLevels.whereType<KeyFrameDirective>()) {
    print('KeyFrame Name: ${keyframe.name}');
    print('KeyFrame Name: ${keyframe}');
    print('-----');
  }
  print('-----');

  // print(stylesheet.span.text);
}

class _Visitor extends Visitor {
  List<RuleSet> ruleSets = [];

  @override
  void visitRuleSet(RuleSet ruleSet) {
    ruleSets.add(ruleSet);
  }
}

// css to scoped css
// save in .module.css

// convert attributes
// save css

