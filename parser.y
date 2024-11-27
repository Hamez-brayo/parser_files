%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Include string.h to fix strcmp error
#include "ast.h"
#include "symbol.h"

int yy_scan_string(const char *str);
extern int yylex();
void yyerror(const char *s);

ASTNode *root;  // Global variable for AST root
%}

%union {
    int num;
    char *id;
    struct ASTNode *ast;
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token IF ELSE
%token GT LT EQ NEQ GTE LTE ASSIGN

%type <ast> expression term factor assignment statement conditional comparison

%%

program:
    statement ';' { root = $1; }
;

statement:
    expression { $$ = $1; }
    | assignment { $$ = $1; }
    | conditional { $$ = $1; }
;

assignment:
    IDENTIFIER '=' expression {
        insertSymbol($1, "int", 0);
        $$ = createBinaryNode("assign", createIdentifierNode($1), $3);
    }
    | IDENTIFIER '[' expression ']' '=' expression {
        $$ = createBinaryNode("array_assign", createArrayRefNode($1, $3), $6);
    }
;

conditional:
    IF '(' comparison ')' statement %prec THEN {
        $$ = createIfElseNode($3, $5, NULL);
    }
    | IF '(' comparison ')' statement ELSE statement %prec ELSE {
        $$ = createIfElseNode($3, $5, $7);
    }
;

expression:
    expression '+' term { $$ = createBinaryNode("add", $1, $3); }
    | expression '-' term { $$ = createBinaryNode("sub", $1, $3); }
    | term { $$ = $1; }
;

term:
    term '*' factor { $$ = createBinaryNode("mul", $1, $3); }
    | term '/' factor { $$ = createBinaryNode("div", $1, $3); }
    | factor { $$ = $1; }
;

factor:
    NUMBER { $$ = createTerminalNode("number", $1); }
    | IDENTIFIER { $$ = createIdentifierNode($1); }
    | IDENTIFIER '[' expression ']' { $$ = createArrayRefNode($1, $3); }
    | '(' expression ')' { $$ = $2; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter your expressions (end with ; and type 'exit' to quit):\n");
    while (1) {
        char input[256];
        printf(">> ");
        if (fgets(input, sizeof(input), stdin) == NULL) {
            break;  // Handle end of input
        }
        if (strcmp(input, "exit\n") == 0) {
            break;  // Exit condition
        }
        yy_scan_string(input); // Pass input to the lexer
        if (yyparse() == 0) {  // Call the parser
            printSymbolTable();
            if (root != NULL) {
                printAST(root, 0); // Print the AST
            } else {
                printf("Error: syntax error\n");
            }
        }
    }
    return 0;
}
