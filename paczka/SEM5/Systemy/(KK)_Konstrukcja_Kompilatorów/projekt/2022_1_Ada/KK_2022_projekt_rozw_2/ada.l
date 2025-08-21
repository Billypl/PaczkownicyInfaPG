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



%%

	/* usuwanie białych znaków */


		/* komentarze */



	/* stałe napisowe STRING_CONST */


	/* stałe znakowe CHARACTER_CONST */


	/* stałe całkowite INTEGER_CONST */


	/* stałe zmiennoprzecinkowe FLOAT_CONST */


	/* słowa kluczowe KW_słowo */
with	{ return process_token(yytext, "KW_WITH", "", KW_WITH); }

	/* identyfikatory */


	/* operatory przypisania, zakresu, <=, >= */

	/* pozostałe znaki - identyfikatorem jest kod znaku */


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
