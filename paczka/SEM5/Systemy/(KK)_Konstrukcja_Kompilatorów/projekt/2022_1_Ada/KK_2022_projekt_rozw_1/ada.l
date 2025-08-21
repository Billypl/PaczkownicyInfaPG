%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STR_LEN	100
#include "ada.tab.h"
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID); 
char *strnncpy(char *dst, const char *src, const int n);
%}

%x NAPIS
%x KOMENTARZ

%%

	/* biale znaki */
[ \n\t]+ ;

	/* komentarze */
	/*--.* ;*/
	/* z uzyciem warunkow poczatkowych */
<INITIAL>-- {yymore(); BEGIN(KOMENTARZ);}
<KOMENTARZ>\n BEGIN(INITIAL);
<KOMENTARZ>. ;

	/* stałe napisowe STRING_CONST */
	/*\"[^\"\n]*\"	return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);*/
	/* z uzyciem warunkow poczatkowych */
<INITIAL>\" {BEGIN(NAPIS); yymore();}
<NAPIS>\"\" {fprintf(stderr, "Cudzyslowia w napisie!\n"); BEGIN(INITIAL);}
<NAPIS>\" {BEGIN(INITIAL); return process_token(yytext, "STRING_CONST", yytext, STRING_CONST); }
<NAPIS>. yymore();
<NAPIS>\n {fprintf(stderr, "Brak konca napisu!\n"); BEGIN(INITIAL);}

	/* stałe znakowe CHARACTER_CONST */
\'[^\'\n]\'	return process_token(yytext, "CHARACTER_CONST", yytext, CHARACTER_CONST);

	/* stałe całkowite INTEGER_CONST */
[0-9]+	return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);

	/* stałe zmiennoprzecinkowe FLOAT_CONST */
[0-9]+\.[0-9]+(e[+-]?[0-9]+)?	return process_token(yytext, "FLOAT_CONST", yytext, FLOAT_CONST);

	/* słowa kluczowe KW_słowo */
(?i:with)	return process_token(yytext, "KW_WITH", "", KW_WITH);
(?i:use)	return process_token(yytext, "KW_USE", "", KW_USE);
(?i:procedure)	return process_token(yytext, "KW_PROCEDURE", "", KW_PROCEDURE);
(?i:is)	return process_token(yytext, "KW_IS", "", KW_IS);
(?i:constant)	return process_token(yytext, "KW_CONSTANT", "", KW_CONSTANT);
(?i:begin)	return process_token(yytext, "KW_BEGIN", "", KW_BEGIN);
(?i:end)	return process_token(yytext, "KW_END", "", KW_END);
(?i:for)	return process_token(yytext, "KW_FOR", "", KW_FOR);
(?i:in)	return process_token(yytext, "KW_IN", "", KW_IN);
(?i:range)	return process_token(yytext, "KW_RANGE", "", KW_RANGE);
(?i:loop)	return process_token(yytext, "KW_LOOP", "", KW_LOOP);
(?i:package)	return process_token(yytext, "KW_PACKAGE", "", KW_PACKAGE);
(?i:body)	return process_token(yytext, "KW_BODY", "", KW_BODY);
(?i:out)	return process_token(yytext, "KW_OUT", "", KW_OUT);
(?i:if)	return process_token(yytext, "KW_IF", "", KW_IF);
(?i:then)	return process_token(yytext, "KW_THEN", "", KW_THEN);
(?i:else)	return process_token(yytext, "KW_ELSE", "", KW_ELSE);
(?i:array)	return process_token(yytext, "KW_ARRAY", "", KW_ARRAY);
(?i:record)	return process_token(yytext, "KW_RECORD", "", KW_RECORD);
(?i:of)	return process_token(yytext, "KW_OF", "", KW_OF);


	/* identyfikatory */
[a-zA-Z][a-zA-Z0-9_]*	return process_token(yytext, "IDENT", yytext, IDENT);

	/* operatory wieloznakowe - przypisania, zakresu, <=, >= */
:=	return process_token(yytext, "ASSIGN", "", ASSIGN);
".."	return process_token(yytext, "RANGE", "", RANGE);
\<=	return process_token(yytext, "LE", "", LE);
\>=	return process_token(yytext, "GE", "", GE);

	/* pozostałe znaki - identyfikatorem jest kod znaku */
[\.;\(\)*+-:'=,]	return process_token(yytext, yytext, "", yytext[0]);

%%

int yywrap()
{
  return 1;
}

/* Nazwa:	strnncpy
 * Cel:		Kopiuje zadaną liczbę znaków napisu umieszczając na końcu
 *		znak o kodzie 0.
 * Parametry:	dst		- (o) napis, do którego ma nastąpić kopiowanie;
 *		src		- (i) napis, który ma być kopiowany;
 *		n		- (i) maksymalna liczba znaków do kopiowania.
 * Zwraca:	dst.
 * Uwagi:	strncpy nie umieszcza znaku o kodzie 0 za kopiowanym napisem.
 *		Napis docelowy musi mieć miejsce na dodatkowy n+1 znak.
 */
char *
strnncpy(char *dst, const char *src, const int n)
{
  if (n > 0) {
    strncpy(dst, src, n);
  }
  dst[n] = '\0';
  return dst;
}/*strnncpy*/

/* Nazwa:	process_token
 * Cel:		Wypisanie informacji o wykrytym elemencie i przekazanie
 *		tej informacji wyżej z ewentualną wartością elementu, jeśli
 *		takowa występuje.
 * Parametry:	text		- (i) tekst, do którego nastąpiło dopasowanie;
 *		TokenType	- (i) napis będący tekstową reprezentacją
 *					nazwy typu elementu;
 *		TokenVal	- (i) wartość elementu, o ile występuje;
 *		TokenID		- (i) identyfikator typu elementu zadeklarowany
 *					za pomocą dyrektywy %token
 *					w pliku ada.y.
 * Zwraca:	Identyfikator typu elementu (TokenID).
 * Uwagi:	Informacja o wykrytym elemencie zwracana jest
 *		w trzech kolumnach. W pierwszej wypisywany jest tekst,
 *		do którego nastąpiło dopasowanie, w drugiej - typ elementu,
 *		w trzeciej - wartość elementu (o ile występuje).
 */
int process_token(const char *text, const char *TokenType,
		  const char *TokenVal, const int TokenID)
{
  int l;
  printf("%-20.20s%-15s %s\n", text, TokenType, TokenVal);
  switch (TokenID) {

  case INTEGER_CONST:
    yylval.i = atoi(text); break;

  case FLOAT_CONST:
    yylval.d = atof(text); break;

  case IDENT:
    strncpy(yylval.s, text, MAX_STR_LEN); break;

  case STRING_CONST:
    l = strlen(text);
    strnncpy(yylval.s, text + 1, l - 2 <= MAX_STR_LEN ? l - 1 : MAX_STR_LEN);
    break;

  case CHARACTER_CONST:
    yylval.i = text[1]; break;

  }
  return(TokenID);
}
