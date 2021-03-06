library peg.frontend_analyzer;

import "dart:collection";

import 'package:lists/lists.dart';
import 'package:peg/expressions.dart';
import 'package:peg/grammar.dart';
import 'package:peg/production_rule.dart';
import 'package:peg/expression_visitors.dart';
import 'package:strings/strings.dart';

part 'src/frontend_analyzer/always_success_expressions_resolver.dart';
part 'src/frontend_analyzer/always_zero_or_more_expressions_resolver.dart';
part 'src/frontend_analyzer/automaton_resolver.dart';
part 'src/frontend_analyzer/expected_strings_resolver.dart';
part 'src/frontend_analyzer/expected_terminals_resolver.dart';
part 'src/frontend_analyzer/expression_able_not_consume_input_resolver.dart';
part 'src/frontend_analyzer/expression_callers_resolver.dart';
part 'src/frontend_analyzer/expression_level_resolver.dart';
part 'src/frontend_analyzer/expression_resolver.dart';
part 'src/frontend_analyzer/expression_hierarchy_resolver.dart';
part 'src/frontend_analyzer/expression_ownership_resolver.dart';
part 'src/frontend_analyzer/expression_with_actions_resolver.dart';
part 'src/frontend_analyzer/frontend_analyzer.dart';
part 'src/frontend_analyzer/invocations_resolver.dart';
part 'src/frontend_analyzer/left_expressions_resolver.dart';
part 'src/frontend_analyzer/repetition_expressions_resolver .dart';
part 'src/frontend_analyzer/right_expressions_resolver.dart';
part 'src/frontend_analyzer/rule_expression_resolver.dart';
part 'src/frontend_analyzer/start_characters_resolver.dart';
part 'src/frontend_analyzer/terminal_rules_resolver.dart';