#include "parser.tab.h"  // Include the parser tab header to define tokens

%%

[0-9]+              { yylval.num = atoi(yytext); return NUMBER; }
"if"                { return IF; }
"else"              { return ELSE; }
">"                 { return GT; }
"<"                 { return LT; }
"=="                { return EQ; }
"!="                { return NEQ; }
">="                { return GTE; }
"<="                { return LTE; }
"="                 { return ASSIGN; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }
"("                 { return '('; }
")"                 { return ')'; }
"["                 { return '['; }
"]"                 { return ']'; }
";"                 { return ';'; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return IDENTIFIER; }
.                   { printf("Lexer: Unrecognized character: %s\n", yytext); }

%%

int yywrap() {
    return 1; 
}
