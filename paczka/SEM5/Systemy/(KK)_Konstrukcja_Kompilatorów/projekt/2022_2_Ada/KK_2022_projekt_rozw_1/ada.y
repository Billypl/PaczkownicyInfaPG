%{
#include	<stdio.h>
#include	<string.h>
#define MAX_STR_LEN	100
  void found( const char *nonterminal, const char *value );
  int yylex(void);
  void yyerror(const char *txt);
%}

%union {
  char s[ MAX_STR_LEN + 1 ];
  int i;
  double d;
}

/* keywords */
%token <i> KW_WITH KW_USE KW_PROCEDURE KW_IS KW_CONSTANT
%token <i> KW_BEGIN KW_END KW_FOR KW_IN KW_RANGE KW_LOOP
%token <i> KW_PACKAGE KW_BODY KW_OUT KW_IF KW_THEN KW_ELSE
%token <i> KW_ARRAY KW_RECORD KW_DOWNTO KW_OF
/* literal values */
%token <s> STRING_CONST
%token <i> INTEGER_CONST
%token <d> FLOAT_CONST
%token <i> CHARACTER_CONST
/* operators */
%token <i> ASSIGN RANGE LE GE
/* other */
%token <s> IDENT

 /* nonterminals */
%type <s> PROC_DEFINITION PROC_HEADER PROC_DECL PACKAGE_DECL PACKAGE_BODY
%type <s> VAR_DECL BLOCK PROCEDURE_CALL NAME IDENT_LIST

%left '+' '-'
%left '*' '/'
%right NEG

%%

 /* GRAMMAR */
 /* Gramatyka zawiera specyfikacje kontekstu (CONTEXT_SPECS) i następująca
    po nich definicję procedury (PROC_DEFINITION) */
Grammar: /*{ yyerror( "Empty input source is not valid!" ); YYERROR; }*/ | error | CONTEXT_SPECS PROC_DEFINITION;

/* CONTEXT_SPECS */
/* Specyfikacje kontekstu to ciąg (może być pusty) specyfikacji kontekstu
   (CONTEXT_SPEC) */
CONTEXT_SPECS: /* nic */ | CONTEXT_SPECS CONTEXT_SPEC;

/* CONTEXT_SPEC */
/* Specyfikacja kontekstu to klauzula with (WITH_CLAUSE),
   po której może wystąpic klauzula use (USE_CLAUSE) */
CONTEXT_SPEC: WITH_CLAUSE | WITH_CLAUSE USE_CLAUSE {
	found("CONTEXT_SPEC", "");
};

/* WITH_CLAUSE */
/* Zaczyna się słowem kluczowym with, potem jest lista nazw (NAME_LIST)
   i średnik */
WITH_CLAUSE: KW_WITH NAME_LIST ';' {
	found("WITH_CLAUSE", "");
};

/* NAME_LIST */
/* Lista nazw (NAME) oddzielonych przecinkami */
NAME_LIST: NAME | NAME_LIST ',' NAME;

/* NAME */
/* Lista identyfikatorow oddzielonych kropkami */
NAME: IDENT | NAME '.' IDENT;

/* USE_CLAUSE */
/* Słowo kluczowe use, po czym następuje lista nazw i średnik */
USE_CLAUSE: KW_USE NAME_LIST ';' {
	found("USE_CLAUSE", "");
};

/* PROC_DEFINITION */
/* Definicja procedury to nagłówek procedury (PROC_HEADER), po czym następuje
 słowo kluczowe is, deklaracje (DECLS), blok (BLOCK) i średnik */
PROC_DEFINITION: PROC_HEADER KW_IS DECLS BLOCK ';' {
	found("PROC_DEFINITION", $1);
};

/* PROC_HEADER */
/* słowo kluczowe procedura i identyfikator, po czym mogą wystąpić w nawiasach
 parametry formalne (FORMAL_PARAM_LIST) */
PROC_HEADER: KW_PROCEDURE IDENT {
	found("PROC_HEADER", $2);
} | KW_PROCEDURE IDENT '(' FORMAL_PARAM_LIST ')' {
	found("PROC_HEADER", $2);
};

/* FORMAL_PARAM_LIST */
/* Lista parametrów formalnych (FORMAL_PARAM) oddzielonych średnikami */
FORMAL_PARAM_LIST: FORMAL_PARAM | FORMAL_PARAM_LIST ';' FORMAL_PARAM;

/* FORMAL_PARAM */
/* Identyfikator, dwukropek, określenie kierunku (IN_OUT) i identyfikator */
FORMAL_PARAM: IDENT ':' IN_OUT IDENT;

/* IN_OUT */
/* Określenie kierunku parametrów to słowo kluczowe in (parametr wejściowy)
   lub słowo kluczowe out (parametr wyjściowy) lub ciąg in out */
IN_OUT: KW_IN | KW_OUT | KW_IN KW_OUT;

/* DECLS */
/* Deklaracje to (możliwie pusty) ciąg deklaracji (DECL) */
DECLS: /* nic */ | DECL | DECLS DECL;

/* DECL */
/* Deklaracja to deklaracja pakietu (PACKAGE_DECL)
   lub ciało pakietu (PACKAGE_BODY) lub definicja procedury (PROC_DEFINITION)
   lub deklaracja zmiennej (VAR_DECL) lub deklaracja stałej (CONST_DECL)
   lub klauzula with lub klauzula use
*/
DECL: PACKAGE_DECL | PACKAGE_BODY | PROC_DEFINITION | VAR_DECL | CONST_DECL | WITH_CLAUSE | USE_CLAUSE;

/* PACKAGE_DECL */
/* Słowo kluczowe package, identyfikator, słowo kluczowe is,
   deklaracje procedur (PROC_DECLS), słowo kluczowe end,
   identyfikator i średnik */
PACKAGE_DECL: KW_PACKAGE IDENT KW_IS PROC_DECLS KW_END IDENT ';' {
	found("PACKAGE_DECL", $2);
};

/* PROC_DECLS */
/* Możliwie pusty ciąg deklaracji procedur (PROC_DECL) */
PROC_DECLS: /* nic */ | PROC_DECL | PROC_DECLS PROC_DECL;

/* PROC_DECL */
/* Nagłówek procedury (PROC_HEADER) i średnik */
PROC_DECL: PROC_HEADER ';' {
	found("PROC_DECL", $1);
};

/* PACKAGE_BODY */
/* Słowo kluczowe package, słowo kluczowe body, identyfikator,
   słowo kluczowe is, deklaracje (DECLS), słowo kluczowe end, identyfikator
   i średnik
*/
PACKAGE_BODY: KW_PACKAGE KW_BODY IDENT KW_IS DECLS KW_END IDENT ';' {
	found("PACKAGE_BODY", $3);
};

/* VAR_DECL */
/* lista identyfikatorów, dwukropek, typ (TYPE),
   inicjalizacja (INITIALIZATION) i średnik */
VAR_DECL: IDENT_LIST ':' TYPE INITIALIZATION ';' {
	found("VAR_DECL", $1);
};

/* IDENT_LIST */
/* lista identyfikatorów oddzielonych przecinkami */
IDENT_LIST: IDENT | IDENT_LIST ',' IDENT;

/* TYPE */
/* typ może być identyfikatorem,
   albo słowem kluczowym ARRAY, lewym nawiasem okrągłym,
   rozmiarami (DIMENSIONS), prawym nawiasem okrągłym, słowem kluczowym OF
   i typem,
   albo słowem kluczowym RECORD, polami (FIELDS), słowem kluczowym END i słowem
   kluczowym RECORD */
TYPE: IDENT | KW_ARRAY '(' DIMENSIONS ')' KW_OF TYPE | KW_RECORD FIELDS KW_END KW_RECORD; /* TODO? */

/* DIMENSIONS */
/* niepusta lista elementów: wartość stała (CONST_VALUE),
   operator RANGE i wartość stała, rozdzielona przecinkami */
DIMENSIONS: CONST_VALUE RANGE CONST_VALUE | DIMENSIONS CONST_VALUE RANGE CONST_VALUE;

/* CONST_VALUE */
/* stała całkowita lub znakowa */
CONST_VALUE: INTEGER_CONST | CHARACTER_CONST;

/* FIELDS */
/* niepusty ciąg pól (FIELD) */
FIELDS: FIELD | FIELDS FIELD;

/* FIELD */
/* pole składa się z listy identyfikatorów (IDENT_LIST), dwukropka, typu (TYPE)
   i średnika */
FIELD: IDENT_LIST ':' TYPE ';';

/* CONST_DECL */
/* Lista identyfikatorów, dwukropek, słowo kluczowe constant, identyfikator,
 operator przypisania, wyrażenie i średnik */
CONST_DECL: IDENT_LIST ':' KW_CONSTANT IDENT ASSIGN EXPR ';' {
	found("CONST_DECL", $1);
};

/* INITIALIZATION */
/* Może być pusta lub składać się z operatora przypisania i wyrażenia */
INITIALIZATION: /* nic */ | ASSIGN EXPR;

/* EXPR */
/* Może być stałą całkowitą (INTEGER_CONST),
   stałą zmiennoprzecinkową (FLOAT_CONST), stałą znakową (CHARACTER_CONST),
   stałą napisową (STRING_CONST), wyrażeniem w nawiasach, wywołaniem
   procedury (PROCEDURE_CALL), suma, roznicą, iloczynem i ilorazem wyrażen,
   a także wyrażeniem ujemnym (minus jednoargumentowy)
*/
EXPR: INTEGER_CONST | FLOAT_CONST | CHARACTER_CONST | STRING_CONST | '(' EXPR ')' | PROCEDURE_CALL | EXPR '+' EXPR | EXPR '-' EXPR | EXPR '*' EXPR | EXPR '/' EXPR | '-' EXPR;

/* BLOCK */
/* Słowo kluczowe begin, instrukcje (STATEMENTS), słowo kluczowe end
 i identyfikator */
BLOCK: KW_BEGIN STATEMENTS KW_END IDENT {
	found("BLOCK", "");
};

/* STATEMENTS */
/* Ciąg (może być pusty) instrukcji (STATEMENT) */
STATEMENTS: /* nic */ | STATEMENT | STATEMENTS STATEMENT;

/* STATEMENT */
/* Instrukcja może być:
   przypisaniem (nazwa (NAME), część tablicowa (TAB_TAIL),
   operator przypisania, wyrażenie i średnik),
   wywołaniem procedury (nazwa, część tablicowa i średnik
   wypisywane jako PROCEDURE_CALL),
   pętlą for (FOR_LOOP)
   lub instrukcją warunkową (IF_STATEMENT)
*/
STATEMENT: NAME TAB_TAIL ASSIGN EXPR ';' {
	found("ASSIGNMENT", $1);
} | NAME TAB_TAIL ';' {
	found("PROCEDURE_CALL", $1);
}; | FOR_LOOP {
	found("FOR_LOOP", "");
}; | IF_STATEMENT {
	found("IF_STATEMENT", "");
};

/* TAB_TAIL */
/* Puste lub lista wyrażeń (EXPR_LIST) w nawiasach okrągłych 
   i pola rekordu (FIELD_TAIL) */
TAB_TAIL: /* nic */ | '(' EXPR_LIST ')' FIELD_TAIL;

/* FIELD_TAIL */
/* Puste lub kropka, identyfikator i część tablicowa */
FIELD_TAIL: /* nic */ | '.' IDENT TAB_TAIL;

/* EXPR_LIST */
/* Lista wyrażeń (EXPR) oddzielonych przecinkami */
EXPR_LIST: EXPR | EXPR_LIST ',' EXPR;

/* PROCEDURE_CALL */
/* Wywołanie procedury to nazwa (NAME), atrybut typu (TYPE_ATTR), po których
   może wystąpić lista parametrów aktualnych (ACTUAL_PARAM_LIST) ujęta w nawiasy
   okrągłe
 */
PROCEDURE_CALL: NAME TYPE_ATTR {
	found("PROCEDURE_CALL", $1);
} | NAME TYPE_ATTR '(' ACTUAL_PARAM_LIST ')' {
	found("PROCEDURE_CALL", $1);
};

/* TYPE_ATTR */
/* Atrybut typu może być pusty lub składać się z apostrofu i identyfikatora */
TYPE_ATTR: /* nic */ | '\'' IDENT;

/* ACTUAL_PARAM_LIST */
/* Lista parametrów aktualnych rozdzielonych przecinkami */
ACTUAL_PARAM_LIST: ACTUAL_PARAM | ACTUAL_PARAM_LIST ',' ACTUAL_PARAM;

/* ACTUAL_PARAM */
/* Wyrażenie */
ACTUAL_PARAM: EXPR;

/* FOR_LOOP */
/* Słowo kluczowe for, identyfikator, słowo kluczowe in, specyfikacja zakresu
   (RANGE_SPEC), słowo kluczowe loop, instrukcje (STATEMENTS), słowo kluczowe
   end, słowo kluczowe loop i średnik
 */
FOR_LOOP: KW_FOR IDENT KW_IN RANGE_SPEC KW_LOOP STATEMENTS KW_END KW_LOOP ';';

/* RANGE_SPEC */
/* Może być identyfikatorem lub dwoma wyrażeniami z operatorem RANGE
   między nimi lub identyfikatorem, slowem kluczowym range i dwoma
   wyrażeniami z operatorem RANGE między nimi
*/
RANGE_SPEC: IDENT | EXPR RANGE EXPR | IDENT KW_RANGE EXPR RANGE EXPR;

/* IF_STATEMENT */
/* Słowo kluczowe if, wyrażenie logiczne (LOGICAL_EXPR), słowo kluczowe then,
   instrukcje (STATEMENTS), część else (ELSE_PART), słowo kluczowe end,
   słowo kluczowe if i średnik
 */
IF_STATEMENT: KW_IF LOGICAL_EXPR KW_THEN STATEMENTS ELSE_PART KW_END KW_IF ';';

/* LOGICAL_EXPR */
/* Wyrażenie lub dwa wyrażenia połączone operatorem logicznym
   (LOGICAL_OPERATOR) */
LOGICAL_EXPR: EXPR | EXPR LOGICAL_OPERATOR EXPR;

/* LOGICAL_OPERATOR */
/* Miniejsze, większe, równe, LE i GE */
LOGICAL_OPERATOR: '<' | '>' | "==" | LE | GE;

/* ELSE_PART */
/* Puste lub słowo kluczowe else i instrukcje */
ELSE_PART: /* nic */ | KW_ELSE STATEMENT;

%%

int main( void )
{ 
	printf( "Imie i Nazwisko\n" );
	printf( "yytext              Typ tokena      Wartosc tokena znakowo\n\n" );
	return yyparse();
}

void yyerror( const char *txt)
{
	printf("Syntax error %s\n", txt);
}



void found( const char *nonterminal, const char *value )
{  /* informacja o znalezionych strukturach składniowych (nonterminal) */
	printf( "===== FOUND: %s %s%s%s=====\n", nonterminal, 
			(*value) ? "'" : "", value, (*value) ? "'" : "" );
}
