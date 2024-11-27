
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

static Symbol *symbolTable = NULL;

void insertSymbol(char *name, char *type, int scope) {
    Symbol *symbol = (Symbol *)malloc(sizeof(Symbol));
    symbol->name = strdup(name);
    symbol->type = strdup(type);
    symbol->scope = scope;
    symbol->next = symbolTable;
    symbolTable = symbol;
}

Symbol *lookupSymbol(char *name) {
    Symbol *current = symbolTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

void printSymbolTable(void) {
    Symbol *current = symbolTable;
    printf("Symbol Table:\n");
    printf("Name\tType\tScope\n");
    while (current != NULL) {
        printf("%s\t%s\t%d\n", current->name, current->type, current->scope);
        current = current->next;
    }
}
