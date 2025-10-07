%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* --- Prototipos --- */
int yylex(void);
void yyerror(const char *s);

/* --- Estructuras para Backpatching --- */
typedef struct list {
    int quad_index;
    struct list *next;
} list;

// Atributos para expresiones booleanas (B)
typedef struct {
    list *truelist;
    list *falselist;
} b_attr;

// Atributos para sentencias (S)
typedef struct {
    list *nextlist;
} s_attr;

/* --- Generador de Código de Tres Direcciones (Cuádruplas) --- */
#define MAX_QUADS 1000
char *quads[MAX_QUADS];
int nextquad = 0;

int newlabel() {
    return nextquad;
}

// Genera una nueva cuádrupla
void gen(char *code) {
    if (nextquad < MAX_QUADS) {
        quads[nextquad] = strdup(code);
        nextquad++;
    } else {
        yyerror("Error: Se ha excedido el máximo de cuádruplas.");
    }
}

// Crea una lista con un solo índice de cuádrupla
list* makelist(int quad_index) {
    list *new_list = (list*)malloc(sizeof(list));
    new_list->quad_index = quad_index;
    new_list->next = NULL;
    return new_list;
}

// Fusiona dos listas
list* merge(list *l1, list *l2) {
    if (!l1) return l2;
    if (!l2) return l1;
    list *p = l1;
    while (p->next) {
        p = p->next;
    }
    p->next = l2;
    return l1;
}

// Rellena los saltos pendientes en una lista con una etiqueta de destino
void backpatch(list *l, int label) {
    char target[20];
    sprintf(target, "%d", label);
    list *p = l;
    while (p) {
        char *quad_str = quads[p->quad_index];
        size_t len = strlen(quad_str);
        quads[p->quad_index] = realloc(quad_str, len + strlen(target) + 1);
        strcat(quads[p->quad_index], target);
        p = p->next;
    }
}

// Imprime el código generado
void print_quads() {
    printf("\n--- CÓDIGO DE TRES DIRECCIONES GENERADO ---\n");
    for (int i = 0; i < nextquad; i++) {
        printf("%d: %s\n", i, quads[i]);
    }
    printf("------------------------------------------\n");
}

%}

%union {
    b_attr *b; 
    s_attr *s; 
    int label; 
    char* str; 
}

// Terminales (tokens)
%token IF ELSE WHILE ASSIGN TRUE FALSE
%token <str> ID RELOP

// No terminales y sus tipos
%type <b> B
%type <s> P S S_List
%type <label> M N

%left OR
%left AND
%right NOT

%%
P   : S_List {
        printf("Análisis sintáctico completado con éxito.\n");
        print_quads();
    }
;

S_List : S {
            $$ = $1;
        }
    | S_List M S {
            backpatch($1->nextlist, $2);
            $$ = $3;
        }
;

// Sentencia S
S   : ASSIGN {
            char buffer[50];
            sprintf(buffer, "ID = ID");
            gen(buffer);
            $$ = (s_attr*)malloc(sizeof(s_attr));
            $$->nextlist = NULL;
        }
    | IF '(' B ')' M S { 
            // $3 es B, $5 es M (inicio de S), $6 es S
            backpatch($3->truelist, $5);
            $$ = (s_attr*)malloc(sizeof(s_attr));
            $$->nextlist = merge($3->falselist, $6->nextlist);
        }
    | IF '(' B ')' M S N ELSE M S { 
            // $3=B, $5=M1, $6=S1, $7=N, $9=M2, $10=S2
            backpatch($3->truelist, $5);
            backpatch($3->falselist, $9);
            $$ = (s_attr*)malloc(sizeof(s_attr));
            $$->nextlist = merge(merge($6->nextlist, $7->nextlist), $10->nextlist);
        }
    | WHILE M '(' B ')' M S {
            // $2=M1 (inicio del while), $4=B, $6=M2 (inicio de S), $7=S
            backpatch($7->nextlist, $2);
            backpatch($4->truelist, $6);
            $$ = (s_attr*)malloc(sizeof(s_attr));
            $$->nextlist = $4->falselist;
            char buffer[50];
            sprintf(buffer, "goto %d", $2);
            gen(buffer);
        }
    | '{' S_List '}' {
            $$ = $2;
        }
;

M   : /* epsilon */ {
        $$ = newlabel();
    }
;

N   : /* epsilon */ {
        $$ = (int)makelist(nextquad);
        gen("goto "); 
    }
;

// Expresiones Booleanas B
B   : B OR M B {
        // $1=B1, $3=M, $4=B2
        backpatch($1->falselist, $3);
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = merge($1->truelist, $4->truelist);
        $$->falselist = $4->falselist;
    }
    | B AND M B {
        // $1=B1, $3=M, $4=B2
        backpatch($1->truelist, $3);
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = $4->truelist;
        $$->falselist = merge($1->falselist, $4->falselist);
    }
    | NOT B {
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = $2->falselist;
        $$->falselist = $2->truelist;
    }
    | ID RELOP ID {
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = makelist(nextquad);
        $$->falselist = makelist(nextquad + 1);
        char buffer[50];
        sprintf(buffer, "if %s %s %s goto ", "id1", $2, "id3");
        gen(buffer);
        gen("goto ");
    }
    | TRUE {
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = makelist(nextquad);
        $$->falselist = NULL;
        gen("goto ");
    }
    | FALSE {
        $$ = (b_attr*)malloc(sizeof(b_attr));
        $$->truelist = NULL;
        $$->falselist = makelist(nextquad);
        gen("goto ");
    }
    | '(' B ')' {
        $$ = $2;
    }
;
%%

#include <ctype.h>

char *source_code;
int current_pos = 0;

int yylex() {
    while (source_code[current_pos] == ' ' || source_code[current_pos] == '\n' || source_code[current_pos] == '\t') {
        current_pos++;
    }

    if (source_code[current_pos] == '\0') {
        return 0; // Fin de la entrada
    }
    
    // Palabras clave
    if (strncmp(&source_code[current_pos], "if", 2) == 0) { current_pos += 2; return IF; }
    if (strncmp(&source_code[current_pos], "then", 4) == 0) { current_pos += 4; return THEN; }
    if (strncmp(&source_code[current_pos], "else", 4) == 0) { current_pos += 4; return ELSE; }
    if (strncmp(&source_code[current_pos], "while", 5) == 0) { current_pos += 5; return WHILE; }
    if (strncmp(&source_code[current_pos], "true", 4) == 0) { current_pos += 4; return TRUE; }
    if (strncmp(&source_code[current_pos], "false", 5) == 0) { current_pos += 5; return FALSE; }

    // Operadores y otros
    if (source_code[current_pos] == '=') { current_pos++; return ASSIGN; }
    if (source_code[current_pos] == '<' || source_code[current_pos] == '>') {
        yylval.str = strndup(&source_code[current_pos], 1);
        current_pos++;
        return RELOP;
    }
    if (strncmp(&source_code[current_pos], "&&", 2) == 0) { current_pos += 2; return AND; }
    if (strncmp(&source_code[current_pos], "||", 2) == 0) { current_pos += 2; return OR; }
    if (source_code[current_pos] == '!') { current_pos++; return NOT; }

    if (isalpha(source_code[current_pos])) {
        yylval.str = strndup(&source_code[current_pos], 1);
        current_pos++;
        return ID;
    }
    
    return source_code[current_pos++];
}

void yyerror(const char *s) {
    fprintf(stderr, "Error de análisis: %s\n", s);
}

int main() {
    printf("Introduce el código a analizar (ej: while(a<b){x=y;}):\n");
    char buffer[1024];
    fgets(buffer, sizeof(buffer), stdin);
    source_code = buffer;

    yyparse();
    return 0;
}