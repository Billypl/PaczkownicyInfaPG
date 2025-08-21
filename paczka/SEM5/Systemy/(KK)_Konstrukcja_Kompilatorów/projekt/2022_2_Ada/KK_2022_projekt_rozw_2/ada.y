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
Grammar: /*{ yyerror( "Empty input source is not valid!" ); YYERROR; }*/
	| error
	  /* tu dopisać brakującą alternatywę */
;

/* CONTEXT_SPECS */
/* Specyfikacje kontekstu to ciąg (może być pusty) specyfikacji kontekstu
   (CONTEXT_SPEC) */

/* CONTEXT_SPEC */
/* Specyfikacja kontekstu to klauzula with (WITH_CLAUSE),
   po której może wystąpic klauzula use (USE_CLAUSE) */

/* WITH_CLAUSE */
/* Zaczyna się słowem kluczowym with, potem jest lista nazw (NAME_LIST)
   i średnik */

/* NAME_LIST */
/* Lista nazw (NAME) oddzielonych przecinkami */

/* NAME */
/* Lista identyfikatorow oddzielonych kropkami */

/* USE_CLAUSE */
/* Słowo kluczowe use, po czym następuje lista nazw i średnik */

/* PROC_DEFINITION */
/* Definicja procedury to nagłówek procedury (PROC_HEADER), po czym następuje
 słowo kluczowe is, deklaracje (DECLS), blok (BLOCK) i średnik */

/* PROC_HEADER */
/* słowo kluczowe procedura i identyfikator, po czym mogą wystąpić w nawiasach
 parametry formalne (FORMAL_PARAM_LIST) */

/* FORMAL_PARAM_LIST */
/* Lista parametrów formalnych (FORMAL_PARAM) oddzielonych średnikami */

/* FORMAL_PARAM */
/* Identyfikator, dwukropek, określenie kierunku (IN_OUT) i identyfikator */

/* IN_OUT */
/* Określenie kierunku parametrów to słowo kluczowe in (parametr wejściowy)
   lub słowo kluczowe out (parametr wyjściowy) lub ciąg in out */

/* DECLS */
/* Deklaracje to (możliwie pusty) ciąg deklaracji (DECL) */

/* DECL */
/* Deklaracja to deklaracja pakietu (PACKAGE_DECL)
   lub ciało pakietu (PACKAGE_BODY) lub definicja procedury (PROC_DEFINITION)
   lub deklaracja zmiennej (VAR_DECL) lub deklaracja stałej (CONST_DECL)
   lub klauzula with lub klauzula use
*/

/* PACKAGE_DECL */
/* Słowo kluczowe package, identyfikator, słowo kluczowe is,
   deklaracje procedur (PROC_DECLS), słowo kluczowe end,
   identyfikator i średnik */

/* PROC_DECLS */
/* Możliwie pusty ciąg deklaracji procedur (PROC_DECL) */

/* PROC_DECL */
/* Nagłówek procedury (PROC_HEADER) i średnik */

/* PACKAGE_BODY */
/* Słowo kluczowe package, słowo kluczowe body, identyfikator,
   słowo kluczowe is, deklaracje (DECLS), słowo kluczowe end, identyfikator
   i średnik
*/

/* VAR_DECL */
/* lista identyfikatorów, dwukropek, typ (TYPE),
   inicjalizacja (INITIALIZATION) i średnik */

/* IDENT_LIST */
/* lista identyfikatorów oddzielonych przecinkami */

/* TYPE */
/* typ może być identyfikatorem,
   albo słowem kluczowym ARRAY, lewym nawiasem okrągłym,
   rozmiarami (DIMENSIONS), prawym nawiasem okrągłym, słowem kluczowym OF
   i typem,
   albo słowem kluczowym RECORD, polami (FIELDS), słowem kluczowym END i słowem
   kluczowym RECORD */

/* DIMENSIONS */
/* niepusta lista elementów: wartość stała (CONST_VALUE),
   operator RANGE i wartość stała, rozdzielona przecinkami */

/* CONST_VALUE */
/* stała całkowita lub znakowa */

/* FIELDS */
/* niepusty ciąg pól (FIELD) */

/* FIELD */
/* pole składa się z listy identyfikatorów (IDENT_LIST), dwukropka, typu (TYPE)
   i średnika */

/* CONST_DECL */
/* Lista identyfikatorów, dwukropek, słowo kluczowe constant, identyfikator,
 operator przypisania, wyrażenie i średnik */

/* INITIALIZATION */
/* Może być pusta lub składać się z operatora przypisania i wyrażenia */

/* EXPR */
/* Może być stałą całkowitą (INTEGER_CONST),
   stałą zmiennoprzecinkową (FLOAT_CONST), stałą znakową (CHARACTER_CONST),
   stałą napisową (STRING_CONST), wyrażeniem w nawiasach, wywołaniem
   procedury (PROCEDURE_CALL), suma, roznicą, iloczynem i ilorazem wyrażen,
   a także wyrażeniem ujemnym (minus jednoargumentowy)
*/

/* BLOCK */
/* Słowo kluczowe begin, instrukcje (STATEMENTS), słowo kluczowe end
 i identyfikator */

/* STATEMENTS */
/* Ciąg (może być pusty) instrukcji (STATEMENT) */

/* STATEMENT */
/* Instrukcja może być:
   przypisaniem (nazwa (NAME), część tablicowa (TAB_TAIL),
   operator przypisania, wyrażenie i średnik),
   wywołaniem procedury (nazwa, część tablicowa i średnik
   wypisywane jako PROCEDURE_CALL),
   pętlą for (FOR_LOOP)
   lub instrukcją warunkową (IF_STATEMENT)
*/

/* TAB_TAIL */
/* Puste lub lista wyrażeń (EXPR_LIST) w nawiasach okrągłych 
   i pola rekordu (FIELD_TAIL) */

/* FIELD_TAIL */
/* Puste lub kropka, identyfikator i część tablicowa */

/* EXPR_LIST */
/* Lista wyrażeń (EXPR) oddzielonych przecinkami */

/* PROCEDURE_CALL */
/* Wywołanie procedury to nazwa (NAME), atrybut typu (TYPE_ATTR), po których
   może wystąpić lista parametrów aktualnych (ACTUAL_PARAM_LIST) ujęta w nawiasy
   okrągłe
 */

/* TYPE_ATTR */
/* Atrybut typu może być pusty lub składać się z apostrofu i identyfikatora */

/* ACTUAL_PARAM_LIST */
/* Lista parametrów aktualnych rozdzielonych przecinkami */

/* ACTUAL_PARAM */
/* Wyrażenie */

/* FOR_LOOP */
/* Słowo kluczowe for, identyfikator, słowo kluczowe in, specyfikacja zakresu
   (RANGE_SPEC), słowo kluczowe loop, instrukcje (STATEMENTS), słowo kluczowe
   end, słowo kluczowe loop i średnik
 */

/* RANGE_SPEC */
/* Może być identyfikatorem lub dwoma wyrażeniami z operatorem RANGE
   między nimi lub identyfikatorem, slowem kluczowym range i dwoma
   wyrażeniami z operatorem RANGE między nimi
*/

/* IF_STATEMENT */
/* Słowo kluczowe if, wyrażenie logiczne (LOGICAL_EXPR), słowo kluczowe then,
   instrukcje (STATEMENTS), część else (ELSE_PART), słowo kluczowe end,
   słowo kluczowe if i średnik
 */

/* LOGICAL_EXPR */
/* Wyrażenie lub dwa wyrażenia połączone operatorem logicznym
   (LOGICAL_OPERATOR) */

/* LOGICAL_OPERATOR */
/* Miniejsze, większe, równe, LE i GE */

/* ELSE_PART */
/* Puste lub słowo kluczowe else i instrukcje */

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
