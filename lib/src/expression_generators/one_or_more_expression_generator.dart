part of peg.expression_generators;

class OneOrMoreExpressionGenerator extends UnaryExpressionGenerator {
  static const String _CURSOR = GeneralParserClassGenerator.VARIABLE_CURSOR;

  static const String _RESULT = ProductionRuleGenerator.VARIABLE_RESULT;

  static const String _SUCCESS = GeneralParserClassGenerator.VARIABLE_SUCCESS;

  static const String _TESTING = GeneralParserClassGenerator.VARIABLE_TESTING;

  static const String _TEMPLATE = 'TEMPLATE';

  static final String _template = '''
{{#COMMENTS}}
var {{TESTING}};
for (var first = true, reps; ;) {  
  {{#EXPRESSION}}  
  if ($_SUCCESS) {
   if (first) {      
      first = false;
      reps = [$_RESULT];
      {{TESTING}} = $_TESTING;                  
    } else {
      reps.add($_RESULT);
    }
    $_TESTING = $_CURSOR;   
  } else {
    $_SUCCESS = !first;
    if ($_SUCCESS) {      
      $_TESTING = {{TESTING}};
      $_RESULT = reps;      
    } else $_RESULT = null;
    break;
  }  
}''';

  OneOrMoreExpressionGenerator(Expression expression, ProductionRuleGenerator productionRuleGenerator) : super(expression, productionRuleGenerator) {
    if (expression is! OneOrMoreExpression) {
      throw new StateError('Expression must be OneOrMoreExpression');
    }

    addTemplate(_TEMPLATE, _template);
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var testing = productionRuleGenerator.allocateBlockVariable(ExpressionGenerator.VARIABLE_TESTING);
    if (productionRuleGenerator.comment) {
      block.assign('#COMMENTS', '// $_expression');
    }

    block.assign('TESTING', testing);
    block.assign('#EXPRESSION', _generators[0].generate());
    return block.process();
  }
}
