#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to create an array reference node
ASTNode *createArrayRefNode(char *id, ASTNode *index) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->nodeType = strdup("array_ref");
    node->id = strdup(id);
    node->left = index;
    node->right = NULL;
    return node;
}

// Function to create a binary operation node (e.g., assignment, arithmetic)
ASTNode *createBinaryNode(const char *type, ASTNode *left, ASTNode *right) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->nodeType = strdup(type);
    node->left = left;
    node->right = right;
    return node;
}

// Function to create a terminal node (number)
ASTNode *createTerminalNode(const char *type, int value) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->nodeType = strdup(type);
    node->num = value;
    node->left = NULL;
    node->right = NULL;
    return node;
}

// Function to create an identifier node
ASTNode *createIdentifierNode(const char *id) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->nodeType = strdup("identifier");
    node->id = strdup(id);
    node->left = NULL;
    node->right = NULL;
    return node;
}

// Function to create an if-else node (used for conditionals)
ASTNode *createIfElseNode(ASTNode *condition, ASTNode *thenBranch, ASTNode *elseBranch) {
    ASTNode *node = createBinaryNode("if_else", condition, thenBranch);
    node->right = elseBranch;
    return node;
}

// Function to print the AST (abstract syntax tree)
void printAST(ASTNode *node, int depth) {
    if (node == NULL) return;

    for (int i = 0; i < depth; i++) printf("  ");
    printf("%s\n", node->nodeType);

    if (node->left != NULL) {
        printAST(node->left, depth + 1);
    }

    if (node->right != NULL) {
        printAST(node->right, depth + 1);
    }
}

// Function to free the AST nodes (to avoid memory leaks)
void freeAST(ASTNode *node) {
    if (node == NULL) return;

    if (node->left != NULL) freeAST(node->left);
    if (node->right != NULL) freeAST(node->right);

    free(node->nodeType);
    if (node->id != NULL) free(node->id);
    free(node);
}
