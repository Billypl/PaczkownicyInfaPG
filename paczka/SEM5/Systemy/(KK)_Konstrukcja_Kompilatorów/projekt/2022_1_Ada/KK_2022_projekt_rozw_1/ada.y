%{
#include	<stdio.h>
#include	<string.h>
#define MAX_STR_LEN	100
  void found( const char *nonterminal, const char *value );
union YYSTYPE;
int yylex(void);
int yyerror(const char *txt);
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
%token <i> KW_ARRAY KW_RECORD KW_OF
/* literal values */
%token <s> STRING_CONST
%token <i> INTEGER_CONST
%token <d> FLOAT_CONST
%token <i> CHARACTER_CONST
/* operators */
%token <i> ASSIGN RANGE LE GE
/* other */
%token <s> IDENT


%left '+' '-'
%left '*' '/'
%right NEG

%%

 /* GRAMMAR */
Grammar: TOKEN | Grammar TOKEN
	| error
;

TOKEN: KEYWORD | LITERAL_VALUE | OPERATOR | IDENT | OTHER
;

KEYWORD: KW_WITH | KW_USE | KW_PROCEDURE | KW_IS | KW_CONSTANT
	| KW_BEGIN | KW_END | KW_FOR | KW_IN | KW_RANGE | KW_LOOP
	| KW_PACKAGE | KW_BODY | KW_OUT | KW_IF | KW_THEN | KW_ELSE
	| KW_ARRAY | KW_RECORD | KW_OF
;

LITERAL_VALUE: STRING_CONST | INTEGER_CONST | FLOAT_CONST | CHARACTER_CONST
;

OPERATOR: ASSIGN | RANGE | LE | GE
;

OTHER: '.' | ';' | '(' | ')' | '*' | '+' | '-' | ':' | '\'' | '=' | ','
;

%%

int main( void )
{ 
	printf( "Imie i Nazwisko\n" );
	printf( "yytext              Typ tokena      Wartosc tokena znakowo\n\n" );
	return yyparse();
}

int yyerror( const char *txt)
{
	printf("Syntax error %s\n", txt);
	return 0;
}



void found( const char *nonterminal, const char *value )
{  /* informacja o znalezionych strukturach sk³adniowych (nonterminal) */
	printf( "===== FOUND: %s %s%s%s=====\n", nonterminal, 
			(*value) ? "'" : "", value, (*value) ? "'" : "" );
}
