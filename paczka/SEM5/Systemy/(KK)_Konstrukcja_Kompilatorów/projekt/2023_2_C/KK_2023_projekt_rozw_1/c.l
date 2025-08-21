%{
#include <stdio.h> /* printf() */
#include <string.h> /* strcpy */
#include <stdlib.h> /* atoi(), atof() */
#include "common.h" /* MAX_STR_LEN */
#include "c.tab.h" /* declarations for terminal symbols */

#define UNFINISHED_COMMENT_MSG "Unfinished comment opened in line %d\n"
#define UNFINISHED_STRING_MSG "Unfinished string opened in line %d\n"
#define UNFINISHED_INCLUDE_MSG "Unfinished include in line %d\n"
#define KEYWORD(name) return process_token(yytext, #name, "", name); 

/* print information about the terminal symbol found  */
int process_token(const char *text, const char *TokenType,
                  const char *TokenVal, const int TokenID); 

int str_beg = 0;  /* line number for beginning of string */
int comm_beg = 0; /* line number for beginning of comment */
int incl_tag_beg = 0;
int incl_quote_beg = 0;
%}

%option yylineno

/* declaration of start conditions */
/* (start  condition INITIAL does not need to be declared) */
/* ..................... */
%x COMMENT STRING INCLUDE_QUOTE INCLUDE_TAG
%%

 /* removal of multi-line comments using start conditions */
 /* ..................... */
<INITIAL>"/*" { 
    BEGIN(COMMENT); comm_beg=yylineno; 
}
<COMMENT>"*/" BEGIN(INITIAL); 
<COMMENT>.|\n ;

 /* removal of one-line comments using start conditions */
 /* ..................... */
<INITIAL>"//".* ;

 /* detection of error: unexpected closing of comment */
 /* ..................... */
<INITIAL>"*/" fprintf(stderr, "Unexpected closing of comment in line %d\n", yylineno);

 /* detection of strings ".." using start conditions */
 /* ..................... */
<INITIAL>\" {
    BEGIN(STRING); 
    str_beg=yylineno;
    yymore();
 }
<STRING>\" {
    BEGIN(INITIAL);
    return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);
}
<STRING>. yymore();
<STRING>\n {
    fprintf(stderr, UNFINISHED_STRING_MSG, yylineno-1);
    BEGIN(INITIAL);
}

 /* detection of directives in form of #include <name.h> and #include "name.h" */
 /* using start conditions */
 /* ..................... */
<INITIAL>"#include"[\t ]+\" BEGIN(INCLUDE_QUOTE);
<INCLUDE_QUOTE>\" {
    BEGIN(INITIAL);
    incl_quote_beg = yylineno;
    printf("Processing directive #include \"%s\n", yytext);
}
<INCLUDE_QUOTE>. yymore();
<INCLUDE_QUOTE>\n {
    BEGIN(INITIAL);
    fprintf(stderr, UNFINISHED_INCLUDE_MSG, yylineno);
}

<INITIAL>"#include"[\t ]+< BEGIN(INCLUDE_TAG);
<INCLUDE_TAG>> {
    BEGIN(INITIAL);
    incl_tag_beg = yylineno;
    printf("Processing directive #include <%s\n",yytext);
}
<INCLUDE_TAG>. yymore();
<INCLUDE_TAG>\n {
    BEGIN(INITIAL);
    fprintf(stderr, UNFINISHED_INCLUDE_MSG, yylineno);
}

 /* detection of keywords */
 /* ..................... */

<INITIAL>"char"     KEYWORD(KW_CHAR); 
<INITIAL>"unsigned" KEYWORD(KW_UNSIGNED);
<INITIAL>"short"    KEYWORD(KW_SHORT);
<INITIAL>"int"      KEYWORD(KW_INT);
<INITIAL>"long"     KEYWORD(KW_LONG);
<INITIAL>"float"    KEYWORD(KW_FLOAT);
<INITIAL>"void"     KEYWORD(KW_VOID);
<INITIAL>"for"      KEYWORD(KW_FOR)
<INITIAL>"double"   KEYWORD(KW_DOUBLE);
<INITIAL>"if"       KEYWORD(KW_IF);
<INITIAL>"else"     KEYWORD(KW_ELSE);
<INITIAL>"while"    KEYWORD(KW_WHILE);
<INITIAL>"do"       KEYWORD(KW_DO);
<INITIAL>"struct"   KEYWORD(KW_STRUCT);

 /* detection of symbols described with complex regular expressions */
 /* ..................... */
 /*
 %token<i> INTEGER_CONST FLOAT_CONST STRING_CONST CHARACTER_CONST*/
<INITIAL>[a-zA-Z_][a-zA-Z0-9_]* return process_token(yytext, "IDENT", yytext, IDENT);
<INITIAL>(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([eE](\+|-)?[0-9]{1,2})? return process_token(yytext, "FLOAT_CONST", yytext, FLOAT_CONST);
<INITIAL>[0-9]+ return process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST);
<INITIAL>('.')|('\\[0nrtfb]') return process_token(yytext, "CHARACTER_CONST", yytext, CHARACTER_CONST);
<INITIAL>\”[ˆ\”\n]*\” return process_token(yytext, "STRING_CONST", yytext, STRING_CONST);

 /* cutting out white space */
 /* ..................... */
<INITIAL>[\n\t\f\r\s ] ;

 /* multicharacter operators, e.g. ++ */ 
 /* ..................... */
<INITIAL>"++" return process_token(yytext, "INC", "", INC);
<INITIAL>"<=" return process_token(yytext, "LE", "", LE);

 /* single character operator and punctuation */
 /* ..................... */
<INITIAL>[.;,=(){}*+-\[\]] return process_token(yytext, yytext, "", yytext[0]);

%%

/* Name:	strnncpy
 * Purpose:	Copies given number of characters from a stream appending
 *		character with code 0.
 * Parameters:	dst		- (o) string to be copied from;
 *		src		- (i) string to be copied to;
 *		n		- (i) max number of characters to copy.
 * Returns:	dst.
 * Remarks:	strncpy does not append character 0 to the copied string.
 *		Destination string must have room for additional n+1 character.
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

/* Name:	process_token
 * Purpose:	Print information about detected token and pass it up
 *              with its value if present.
 * Parameters:	text            - (i) matched text;
 *              TokenType       - (i) string representing token name;
 *              TokenVal        - (i) token value if present;
 *              TokenID         - (i) token type identifier declared
 *                                      using %token directive
 *                                      in c.y file single character code
 *					(in the parser put into single quotes).
 * Returns:	Token type identifier (TokenID).
 * Remarks:	Info about detected token is printed in 3 columns.
 *		The first one contains matched text, the second - token type,
 *		the third - token value, if it exists.
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
    l = strlen(TokenVal);
    yylval.s[0] = '\0';
    strnncpy(yylval.s, TokenVal+1, l - 2 <= MAX_STR_LEN ? l - 1 : MAX_STR_LEN);
    break;

  case CHARACTER_CONST:
    yylval.i = text[1]; break;

  }
  return(TokenID);
}


int yywrap( void )
{ /* function called at the end of input stream */

  /* Checking whether YY_START is different from INITIAL. */
  /* If it is so, it means that a string or comment has not been closed
     - we print an error message */
  /* ..................... */

  switch(YY_START){
    case COMMENT: 
     fprintf(stderr, UNFINISHED_COMMENT_MSG, comm_beg);
     break;
    case STRING:
     fprintf(stderr, UNFINISHED_STRING_MSG, str_beg);
     break;
    case INCLUDE_TAG:
     fprintf(stderr, UNFINISHED_INCLUDE_MSG, incl_tag_beg);
     break;
    case INCLUDE_QUOTE:
     fprintf(stderr, UNFINISHED_INCLUDE_MSG, incl_quote_beg);
     break;
  }

  return 1;
}


