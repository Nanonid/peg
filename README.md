#peg
==========

PEG (Parsing expression grammar) parsers generator.

Version: 0.0.9

Status: Experimental

Latest version always can be found at https://github.com/mezoni/peg

**Features:**

- Generation of detailed comments
- Generated parsers has no dependencies
- Grammar analytics
- Grammar reporting
- Grammar statistics
- High quality generated source code
- Lookahead mapping tables
- Memoization
- Possibility to trace parsing
- Powerful error and mistakes detection
- Printing grammar
- Terminal and nonterminal symbol recognition

In the future, will be added generator of an alternative PEG (a state machine based) parser.

**Error detection**

- Infinite loops
- Left recursive rules
- Optional expression in choices

**Trace**

Trace information are useful for diagnose the problems.

Trace displayed in the following format:

column, line:state rule padding code position

Eg:

```
94, 8: F* OPEN    '-' Char { $$ = [$1, $3]; (2343)
94, 8:  > Literal '-' Char { $$ = [$1, $3]; (2343)

```

State:

Cache : Match : Direction

Cache:
 
- 'C' - Cache
- ' ' - Not cache

Match:
 
- 'F' - Failed
- ' ' - Succeed

Direction:

- '>' - Enter
- '<' - Leave
- 'S' - Skip (lookahead)

Examples:

- '  >' Enter
- '  <' Leave, success
- ' F<' Leave, failed
- 'C <' Leave, succeed, uses cached result 
- 'CF<' Leave, failed, uses cached result
- '  S' Skip (lookahead), succeed
- ' FS' Skip (lookahead), failed

**Grammar**

```
Grammar <- SPACING Globals? Members? Definition+ EOF

Globals <- "%{" GlobalsBody* "}%" SPACING

GlobalsBody <- !"}%" .

Members <- "{" ActionBody* "}" SPACING

Action <- "{" ActionBody* "}" SPACING

ActionBody <- Action / !"}" .

Definition <- IDENTIFIER LEFTARROW Expression

Expression <- Sequence (SLASH Sequence)*

Sequence <- Prefix+

Prefix <- (AND / NOT)? Suffix Action?

Suffix <- Primary (QUESTION / STAR / PLUS)?

Primary <- IDENTIFIER !LEFTARROW / OPEN Expression CLOSE / Literal / Class / DOT

Literal <- "\'" (!"\'" Char)* "\'" SPACING / "\"" (!"\"" Char)* "\"" SPACING

Class <- "[" (!"]" Range)* "]" SPACING

Range <- Char "-" Char / Char

Char <- "\\" ["'\-\[-\]nrt] / HEX_NUMBER / !"\\" !EOL .

EOF <- !.

IDENTIFIER <- IDENT_START IDENT_CONT* SPACING

IDENT_START <- [A-Z_a-z]

IDENT_CONT <- IDENT_START / [0-9]

LEFTARROW <- "<-" SPACING

SLASH <- "/" SPACING

AND <- "&" SPACING

NOT <- "!" SPACING

QUESTION <- "?" SPACING

STAR <- "*" SPACING

PLUS <- "+" SPACING

OPEN <- "(" SPACING

CLOSE <- ")" SPACING

DOT <- "." SPACING

HEX_NUMBER <- "\\u" [0-9A-Fa-f]+

SPACING <- (SPACE / COMMENT)*

COMMENT <- "#" (!EOL .)* EOL?

SPACE <- [\t ] / EOL

EOL <- "\r\n" / [\n\r]

```

**Example**

Arithmetic grammar

```
%{
part of peg.example.arithmetic;

num _binop(num left, num right, String op) {
  switch(op) {
    case "+":
      return left + right;
    case "-":
      return left - right;
    case "*":
      return left * right;
    case "/":
      return left / right;
    default:
      throw "Unsupported operation $op";  
  }
}

}%

Expr <-
  Sentence EOF { $$ = $1; }

Sentence <-
  SPACES Term (PLUS / MINUS) Sentence { $$ = _binop($2, $4, $3); }
  / Term

Term <-
  Atom (MUL / DIV) Term { $$ = _binop($1, $3, $2); }
  / Atom

Atom <-
  NUMBER
  / OPEN Sentence CLOSE { $$ = $2; }

# Tokens

CLOSE <-
  ')' SPACES

DIV <-
  '/' SPACES { $$ = $1; }

EOF <-
  !.

MINUS <-
  '-' SPACES { $$ = $1; }

MUL <-
  '*' SPACES { $$ = $1; }

NUMBER <-
  [0-9]+ SPACES { $$ = int.parse($1.join()); }

OPEN <-
  '(' SPACES

PLUS <-
  '+' SPACES { $$ = $1; }
 
SPACES <-
  WS*

 WS <-
   [ \n\t\r] / '\r\n'
```

Source code of the generated parser for `arithmetic grammar`

Such (as an arithmetic) grammars parsed faster with a memoization. 

`peg general --comment --lookahead --memoize arithmetic.peg` 

```dart
// This code was generated by a tool.
// Processing tool available at https://github.com/mezoni/peg

part of peg.example.arithmetic;

num _binop(num left, num right, String op) {
  switch(op) {
    case "+":
      return left + right;
    case "-":
      return left - right;
    case "*":
      return left * right;
    case "/":
      return left / right;
    default:
      throw "Unsupported operation $op";  
  }
}
class ArithmeticParser {
  static const int EOF = -1;
  static final List<bool> _lookahead = _unmap([0x800013, 0x3ff01]);
  // '\t', '\n', '\r', ' '
  static final List<bool> _mapping0 = _unmap([0x800013]);
  List _cache;
  int _cachePos;
  List<int> _cacheRule;
  List<int> _cacheState;
  int _ch;
  int _column;
  int _cursor;
  List<String> _expected;
  int _failurePos;
  int _flag;
  String _input;
  int _inputLen;
  int _line;
  List<int> _runes;
  bool success;
  int _testing;
  
  ArithmeticParser(String text) {
    if (text == null) {
      throw new ArgumentError('text: $text');
    }
    _input = text;  
    _inputLen = _input.length;
    _runes = text.runes.toList(growable: false);
    if (_inputLen >= 0x3fffffe8 / 32) {
      throw new StateError('File size to big: $_inputLen');
    }  
    reset(0);    
  }
  
  int get column { 
    if (_column == -1) { 
      _calculatePos(_failurePos); 
    } 
    return _column;       
  } 
   
  int get line { 
    if (_line == -1) { 
      _calculatePos(_failurePos); 
    } 
    return _line;       
  } 
   
  dynamic parse_Atom() {
    // NONTERMINAL
    // Atom <- NUMBER / OPEN Sentence CLOSE
    var $$;  
    // NUMBER / OPEN Sentence CLOSE
    while (true) {
      // NUMBER
      $$ = null;
      success = _ch >= 48 && _ch <= 57 && _lookahead[_ch + -9];
      // Lookahead (NUMBER)
      if (success) $$ = parse_NUMBER();    
      if (!success) {  
        if (_cursor > _testing) _failure(const ["NUMBER"]);
      }
      if (success) break;
      // OPEN Sentence CLOSE
      var ch0 = _ch, pos0 = _cursor;
      while (true) {  
        // OPEN
        $$ = null;
        success = _ch == 40; // '('
        // Lookahead (OPEN)
        if (success) $$ = parse_OPEN();
        if (!success) {
          if (_cursor > _testing) _failure(const ["("]);
          break;  
        }
        var seq = new List(3)..[0] = $$;
        // Sentence
        $$ = null;
        success = _ch >= 9 && _ch <= 57 && _lookahead[_ch + -9];
        // Lookahead (Sentence)
        if (success) $$ = parse_Sentence();    
        if (!success) {  
          if (_cursor > _testing) _failure(null);
          break;  
        }
        seq[1] = $$;
        // CLOSE
        $$ = null;
        success = _ch == 41; // ')'
        // Lookahead (CLOSE)
        if (success) $$ = parse_CLOSE();
        if (!success) {
          if (_cursor > _testing) _failure(const [")"]);
          break;  
        }
        seq[2] = $$;
        $$ = seq;
        if (success) {    
          // OPEN
          final $1 = seq[0];
          // Sentence
          final $2 = seq[1];
          // CLOSE
          final $3 = seq[2];
          $$ = $2;    
        }
        break;  
      }
      if (!success) {
        _ch = ch0;
        _cursor = pos0;
      }
      break;
    }
    return $$;
  }
  
  dynamic parse_CLOSE() {
    // TERMINAL
    // CLOSE <- ")" SPACES
    var $$;  
    // ")" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // ")"
      $$ = _matchString(')', const [")"]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_DIV() {
    // TERMINAL
    // DIV <- "/" SPACES
    var $$;  
    // "/" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // "/"
      $$ = _matchString('/', const ["/"]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // "/"
        final $1 = seq[0];
        // SPACES
        final $2 = seq[1];
        $$ = $1;    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_EOF() {
    // TERMINAL
    // EOF <- !.
    var $$;  
    // !.
    var ch0 = _ch, pos0 = _cursor, testing0 = _testing; 
    _testing = _inputLen + 1;
    // .
    $$ = _matchAny();
    _ch = ch0;
    _cursor = pos0; 
    _testing = testing0;
    $$ = null;
    success = !success;
    if (!success && _cursor > _testing) _failure();
    return $$;
  }
  
  dynamic parse_Expr() {
    // NONTERMINAL
    // Expr <- Sentence EOF
    var $$;  
    // Sentence EOF
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // Sentence
      $$ = null;
      success = _ch >= 9 && _ch <= 57 && _lookahead[_ch + -9];
      // Lookahead (Sentence)
      if (success) $$ = parse_Sentence();    
      if (!success) {  
        if (_cursor > _testing) _failure(null);
        break;  
      }
      var seq = new List(2)..[0] = $$;
      // EOF
      $$ = parse_EOF();
      if (!success) break;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // Sentence
        final $1 = seq[0];
        // EOF
        final $2 = seq[1];
        $$ = $1;    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_MINUS() {
    // TERMINAL
    // MINUS <- "-" SPACES
    var $$;  
    // "-" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // "-"
      $$ = _matchString('-', const ["-"]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // "-"
        final $1 = seq[0];
        // SPACES
        final $2 = seq[1];
        $$ = $1;    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_MUL() {
    // TERMINAL
    // MUL <- "*" SPACES
    var $$;  
    // "*" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // "*"
      $$ = _matchString('*', const ["*"]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // "*"
        final $1 = seq[0];
        // SPACES
        final $2 = seq[1];
        $$ = $1;    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_NUMBER() {
    // TERMINAL
    // NUMBER <- [0-9]+ SPACES
    var $$;  
    // [0-9]+ SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // [0-9]+
      var testing0;
      for (var first = true, reps; ;) {  
        // [0-9]  
        $$ = _matchRange(48, 57);  
        if (success) {
         if (first) {      
            first = false;
            reps = [$$];
            testing0 = _testing;                  
          } else {
            reps.add($$);
          }
          _testing = _cursor;   
        } else {
          success = !first;
          if (success) {      
            _testing = testing0;
            $$ = reps;      
          } else $$ = null;
          break;
        }  
      }
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // [0-9]+
        final $1 = seq[0];
        // SPACES
        final $2 = seq[1];
        $$ = int.parse($1.join());    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_OPEN() {
    // TERMINAL
    // OPEN <- "(" SPACES
    var $$;  
    // "(" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // "("
      $$ = _matchString('(', const ["("]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_PLUS() {
    // TERMINAL
    // PLUS <- "+" SPACES
    var $$;  
    // "+" SPACES
    var ch0 = _ch, pos0 = _cursor;
    while (true) {  
      // "+"
      $$ = _matchString('+', const ["+"]);
      if (!success) break;
      var seq = new List(2)..[0] = $$;
      // SPACES
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (SPACES is optional)
      if (success) $$ = parse_SPACES();
      else success = true;
      seq[1] = $$;
      $$ = seq;
      if (success) {    
        // "+"
        final $1 = seq[0];
        // SPACES
        final $2 = seq[1];
        $$ = $1;    
      }
      break;  
    }
    if (!success) {
      _ch = ch0;
      _cursor = pos0;
    }
    return $$;
  }
  
  dynamic parse_SPACES() {
    // TERMINAL
    // SPACES <- WS*
    var $$;      
    var pos = _cursor;    
    if(pos <= _cachePos) {
      $$ = _getFromCache(12);
    }
    if($$ != null) {
      return $$[0];       
    }  
    // WS*
    var testing0 = _testing; 
    for (var reps = []; ; ) {
      _testing = _cursor;
      // WS
      $$ = null;
      success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
      // Lookahead (WS)
      if (success) $$ = parse_WS();    
      if (!success) {  
        if (_cursor > _testing) _failure(const ["WS"]);
      }
      if (success) {  
        reps.add($$);
      } else {
        success = true;
        _testing = testing0;
        $$ = reps;
        break; 
      }
    }
    _addToCache($$, pos, 12);
    return $$;
  }
  
  dynamic parse_Sentence() {
    // NONTERMINAL
    // Sentence <- SPACES Term (PLUS / MINUS) Sentence / Term
    var $$;      
    var pos = _cursor;    
    if(pos <= _cachePos) {
      $$ = _getFromCache(1);
    }
    if($$ != null) {
      return $$[0];       
    }  
    // SPACES Term (PLUS / MINUS) Sentence / Term
    while (true) {
      // SPACES Term (PLUS / MINUS) Sentence
      var ch0 = _ch, pos0 = _cursor;
      while (true) {  
        // SPACES
        $$ = null;
        success = _ch >= 9 && _ch <= 32 && _lookahead[_ch + -9];
        // Lookahead (SPACES is optional)
        if (success) $$ = parse_SPACES();
        else success = true;
        var seq = new List(4)..[0] = $$;
        // Term
        $$ = null;
        success = _ch >= 40 && _ch <= 57 && _lookahead[_ch + -9];
        // Lookahead (Term)
        if (success) $$ = parse_Term();    
        if (!success) {  
          if (_cursor > _testing) _failure(null);
          break;  
        }
        seq[1] = $$;
        // PLUS / MINUS
        while (true) {
          // PLUS
          $$ = null;
          success = _ch == 43; // '+'
          // Lookahead (PLUS)
          if (success) $$ = parse_PLUS();
          if (!success) {
            if (_cursor > _testing) _failure(const ["+"]);
          }
          if (success) break;
          // MINUS
          $$ = null;
          success = _ch == 45; // '-'
          // Lookahead (MINUS)
          if (success) $$ = parse_MINUS();
          if (!success) {
            if (_cursor > _testing) _failure(const ["-"]);
          }
          break;
        }
        if (!success) break;
        seq[2] = $$;
        // Sentence
        $$ = null;
        success = _ch >= 9 && _ch <= 57 && _lookahead[_ch + -9];
        // Lookahead (Sentence)
        if (success) $$ = parse_Sentence();    
        if (!success) {  
          if (_cursor > _testing) _failure(null);
          break;  
        }
        seq[3] = $$;
        $$ = seq;
        if (success) {    
          // SPACES
          final $1 = seq[0];
          // Term
          final $2 = seq[1];
          // PLUS / MINUS
          final $3 = seq[2];
          // Sentence
          final $4 = seq[3];
          $$ = _binop($2, $4, $3);    
        }
        break;  
      }
      if (!success) {
        _ch = ch0;
        _cursor = pos0;
      }
      if (success) break;
      // Term
      $$ = null;
      success = _ch >= 40 && _ch <= 57 && _lookahead[_ch + -9];
      // Lookahead (Term)
      if (success) $$ = parse_Term();    
      if (!success) {  
        if (_cursor > _testing) _failure(null);
      }
      break;
    }
    _addToCache($$, pos, 1);
    return $$;
  }
  
  dynamic parse_Term() {
    // NONTERMINAL
    // Term <- Atom (MUL / DIV) Term / Atom
    var $$;      
    var pos = _cursor;    
    if(pos <= _cachePos) {
      $$ = _getFromCache(2);
    }
    if($$ != null) {
      return $$[0];       
    }  
    // Atom (MUL / DIV) Term / Atom
    while (true) {
      // Atom (MUL / DIV) Term
      var ch0 = _ch, pos0 = _cursor;
      while (true) {  
        // Atom
        $$ = null;
        success = _ch >= 40 && _ch <= 57 && _lookahead[_ch + -9];
        // Lookahead (Atom)
        if (success) $$ = parse_Atom();    
        if (!success) {  
          if (_cursor > _testing) _failure(null);
          break;  
        }
        var seq = new List(3)..[0] = $$;
        // MUL / DIV
        while (true) {
          // MUL
          $$ = null;
          success = _ch == 42; // '*'
          // Lookahead (MUL)
          if (success) $$ = parse_MUL();
          if (!success) {
            if (_cursor > _testing) _failure(const ["*"]);
          }
          if (success) break;
          // DIV
          $$ = null;
          success = _ch == 47; // '/'
          // Lookahead (DIV)
          if (success) $$ = parse_DIV();
          if (!success) {
            if (_cursor > _testing) _failure(const ["/"]);
          }
          break;
        }
        if (!success) break;
        seq[1] = $$;
        // Term
        $$ = null;
        success = _ch >= 40 && _ch <= 57 && _lookahead[_ch + -9];
        // Lookahead (Term)
        if (success) $$ = parse_Term();    
        if (!success) {  
          if (_cursor > _testing) _failure(null);
          break;  
        }
        seq[2] = $$;
        $$ = seq;
        if (success) {    
          // Atom
          final $1 = seq[0];
          // MUL / DIV
          final $2 = seq[1];
          // Term
          final $3 = seq[2];
          $$ = _binop($1, $3, $2);    
        }
        break;  
      }
      if (!success) {
        _ch = ch0;
        _cursor = pos0;
      }
      if (success) break;
      // Atom
      $$ = null;
      success = _ch >= 40 && _ch <= 57 && _lookahead[_ch + -9];
      // Lookahead (Atom)
      if (success) $$ = parse_Atom();    
      if (!success) {  
        if (_cursor > _testing) _failure(null);
      }
      break;
    }
    _addToCache($$, pos, 2);
    return $$;
  }
  
  dynamic parse_WS() {
    // TERMINAL
    // WS <- [\t-\n\r ] / "\r\n"
    var $$;  
    // [\t-\n\r ] / "\r\n"
    while (true) {
      // [\t-\n\r ]
      $$ = _matchMapping(9, 32, _mapping0);
      if (success) break;
      // "\r\n"
      $$ = _matchString('\r\n', const ["\\r\\n"]);
      break;
    }
    return $$;
  }
  
  void _addToCache(dynamic result, int start, int id) {  
    var cached = _cache[start];
    if (cached == null) {
      _cacheRule[start] = id;
      _cache[start] = [result, _cursor, success];
    } else {    
      var slot = start >> 5;
      var r1 = (slot << 5) & 0x3fffffff;    
      var mask = 1 << (start - r1);    
      if ((_cacheState[slot] & mask) == 0) {
        _cacheState[slot] |= mask;   
        cached = [new List.filled(2, 0), new Map<int, List>()];
        _cache[start] = cached;                                      
      }
      slot = id >> 5;
      r1 = (slot << 5) & 0x3fffffff;    
      mask = 1 << (id - r1);    
      cached[0][slot] |= mask;
      cached[1][id] = [result, _cursor, success];      
    }
    if (_cachePos < start) {
      _cachePos = start;
    }    
  }
  
  void _calculatePos(int pos) {
    if (pos == null || pos < 0 || pos > _inputLen) {
      return;
    }
    _line = 1;
    _column = 1;
    for (var i = 0; i < _inputLen && i < pos; i++) {
      var c = _runes[i];
      if (c == 13) {
        _line++;
        _column = 1;
        if (i + 1 < _inputLen && _runes[i + 1] == 10) {
          i++;
        }
      } else if (c == 10) {
        _line++;
        _column = 1;
      } else {
        _column++;
      }
    }
  }
  
  void _failure([List<String> expected]) {  
    if (_failurePos > _cursor) {
      return;
    }
    if (_cursor > _failurePos) {    
      _expected = [];
     _failurePos = _cursor;
    }
    if (expected != null) {
      _expected.addAll(expected);
    }  
  }
  
  List _flatten(dynamic value) {
    if (value is List) {
      var result = [];
      var length = value.length;
      for (var i = 0; i < length; i++) {
        var element = value[i];
        if (element is Iterable) {
          result.addAll(_flatten(element));
        } else {
          result.add(element);
        }
      }
      return result;
    } else if (value is Iterable) {
      var result = [];
      for (var element in value) {
        if (element is! List) {
          result.add(element);
        } else {
          result.addAll(_flatten(element));
        }
      }
    }
    return [value];
  }
  
  dynamic _getFromCache(int id) {  
    var result = _cache[_cursor];
    if (result == null) {
      return null;
    }    
    var slot = _cursor >> 5;
    var r1 = (slot << 5) & 0x3fffffff;  
    var mask = 1 << (_cursor - r1);
    if ((_cacheState[slot] & mask) == 0) {
      if (_cacheRule[_cursor] == id) {      
        _cursor = result[1];
        success = result[2];      
        if (_cursor < _inputLen) {
          _ch = _runes[_cursor];
        } else {
          _ch = EOF;
        }      
        return result;
      } else {
        return null;
      }    
    }
    slot = id >> 5;
    r1 = (slot << 5) & 0x3fffffff;  
    mask = 1 << (id - r1);
    if ((result[0][slot] & mask) == 0) {
      return null;
    }
    var data = result[1][id];  
    _cursor = data[1];
    success = data[2];
    if (_cursor < _inputLen) {
      _ch = _runes[_cursor];
    } else {
      _ch = EOF;
    }   
    return data;  
  }
  
  String _matchAny() {
    success = _cursor < _inputLen;
    if (success) {
      var result = _input[_cursor++];
      if (_cursor < _inputLen) {
        _ch = _runes[_cursor];
      } else {
        _ch = EOF;
      }    
      return result;
    }
    if (_cursor > _testing) {
      _failure();
    }  
    return null;  
  }
  
  String _matchChar(int ch, List<String> expected) {
    success = _ch == ch;
    if (success) {
      var result = _input[_cursor++];
      if (_cursor < _inputLen) {
        _ch = _runes[_cursor];
      } else {
        _ch = EOF;
      }    
      return result;
    }
    if (_cursor > _testing) {
      _failure(expected);
    }  
    return null;  
  }
  
  String _matchMapping(int start, int end, List<bool> mapping) {
    success = _ch >= start && _ch <= end;
    if (success) {    
      if(mapping[_ch - start]) {
        var result = _input[_cursor++];
        if (_cursor < _inputLen) {
          _ch = _runes[_cursor];
        } else {
          _ch = EOF;
        }      
        return result;
      }
      success = false;
    }
    if (_cursor > _testing) {
       _failure();
    }  
    return null;  
  }
  
  String _matchRange(int start, int end) {
    success = _ch >= start && _ch <= end;
    if (success) { 
      var result = _input[_cursor++];
      if (_cursor < _inputLen) {
        _ch = _runes[_cursor];
      } else {
        _ch = EOF;
      }  
      return result;
    }
    if (_cursor > _testing) {
      _failure();
    }  
    return null;  
  }
  
  String _matchRanges(List<int> ranges) {
    var length = ranges.length;
    for (var i = 0; i < length; i += 2) {
      if (_ch <= ranges[i + 1]) {
        if (_ch >= ranges[i]) {
          var result = _input[_cursor++];
          if (_cursor < _inputLen) {
            _ch = _runes[_cursor];
          } else {
             _ch = EOF;
          }
          success = true;    
          return result;
        }      
      } else break;  
    }
    if (_cursor > _testing) {
      _failure();
    }
    success = false;  
    return null;  
  }
  
  String _matchString(String string, List<String> expected) {
    success = _input.startsWith(string, _cursor);
    if (success) {
      _cursor += string.length;      
      if (_cursor < _inputLen) {
        _ch = _runes[_cursor];
      } else {
        _ch = EOF;
      }    
      return string;      
    } 
    if (_cursor > _testing) {
      _failure(expected);
    }  
    return null; 
  }
  
  void _nextChar([int count = 1]) {  
    success = true;
    _cursor += count; 
    if (_cursor < _inputLen) {
      _ch = _runes[_cursor];
    } else {
      _ch = EOF;
    }    
  }
  
  bool _testChar(int c, int flag) {
    if (c < 0 || c > 127) {
      return false;
    }    
    int slot = (c & 0xff) >> 6;  
    int mask = 1 << c - ((slot << 6) & 0x3fffffff);  
    if ((flag & mask) != 0) {    
      return true;
    }
    return false;           
  }
  
  bool _testInput(int flag) {
    if (_cursor >= _inputLen) {
      return false;
    }
    var c = _runes[_cursor];
    if (c < 0 || c > 127) {
      return false;
    }    
    int slot = (c & 0xff) >> 6;  
    int mask = 1 << c - ((slot << 6) & 0x3fffffff);  
    if ((flag & mask) != 0) {    
      return true;
    }
    return false;           
  }
  
  static List<bool> _unmap(List<int> mapping) {
    var length = mapping.length;
    var result = new List<bool>(length * 31);
    var offset = 0;
    for (var i = 0; i < length; i++) {
      var v = mapping[i];
      for (var j = 0; j < 31; j++) {
        result[offset++] = v & (1 << j) == 0 ? false : true;
      }
    }
    return result;
  }
  
  List<String> get expected {
    var set = new Set<String>();  
    set.addAll(_expected);
    if (set.contains(null)) {
      set.clear();
    }  
    var result = set.toList();
    result.sort(); 
    return result;        
  }
  
  void reset(int pos) {
    if (pos == null) {
      throw new ArgumentError('pos: $pos');
    }
    if (pos < 0 || pos > _inputLen) {
      throw new RangeError('pos');
    }      
    _cursor = pos;
    _cache = new List(_inputLen + 1);
    _cachePos = -1;
    _cacheRule = new List(_inputLen + 1);
    _cacheState = new List.filled(((_inputLen + 1) >> 5) + 1, 0);
    _ch = EOF;  
    _column = -1; 
    _expected = [];
    _failurePos = -1;
    _flag = 0;  
    _line = -1;
    success = true;    
    _testing = -1;
    if (_cursor < _inputLen) {
      _ch = _runes[_cursor];
    }    
  }
  
  String get unexpected {
    if (_failurePos < 0 || _failurePos >= _inputLen) {
      return '';    
    }
    return _input[_failurePos];      
  }
  
}


```
