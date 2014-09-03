part of peg.grammar_generator;

class MethodUnexpectedGenerator extends TemplateGenerator {
  static const String NAME = "unexpected";

  static const String _FAILURE_POS = ParserClassGenerator.VARIABLE_FAILURE_POS;

  static const String _INPUT = ParserClassGenerator.VARIABLE_INPUT;

  static const String _INPUT_LEN = ParserClassGenerator.VARIABLE_INPUT_LEN;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
String get $NAME {
  if ($_FAILURE_POS < 0 || $_FAILURE_POS >= $_INPUT_LEN) {
    return '';    
  }
  return $_INPUT[$_FAILURE_POS];      
}
''';

  MethodUnexpectedGenerator() {
    addTemplate(_TEMPLATE, _template);
  }

  List<String> generate() {
    return getTemplateBlock(_TEMPLATE).process();
  }
}