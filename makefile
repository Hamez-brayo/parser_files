# Compiler
CC = gcc

# Compiler flags
CFLAGS = -g -Wall

# Source files (includes only the manually written source files)
SRCS = ast.c symbol.c

# Generated source files (parser and lexer files)
GEN_SRCS = parser.tab.c lex.yy.c

# Output executable
TARGET = expression_evaluator

# Linking libraries
LIBS = -L/mingw64/lib -lfl  # Linking flex library

# Build rule
all: $(TARGET)

$(TARGET): $(SRCS) $(GEN_SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) $(GEN_SRCS) $(LIBS)

# Rule to generate parser.tab.c and parser.tab.h using bison
parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

# Rule to generate lex.yy.c using flex
lex.yy.c: lexer.l
	flex lexer.l

# Clean rule
clean:
	rm -f $(TARGET) $(SRCS:.c=.o) $(GEN_SRCS) parser.tab.h

# Phony targets
.PHONY: all clean
