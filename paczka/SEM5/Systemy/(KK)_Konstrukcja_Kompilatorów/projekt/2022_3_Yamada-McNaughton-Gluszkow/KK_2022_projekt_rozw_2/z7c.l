%{
  #include	"z7c.tab.h"
  extern int	alphabet_size;	/* size of the alphabet */
  extern char	*alphabet;
  extern char	*in_alphabet; /* in_alphabet[a]=1 if a is in alphabet */
  extern char	*title_start;	/* regular expression as text */
  int		char_no = 0;
  void add(const char c, const int alphabetical);
%}
EPSILON		"-"
EMPTYSET	"#"
%%
[ \t\r\n]	;
[a-z0-9] 	{ yylval = yytext[0]; add(yytext[0], 1); return SYMBOL; }
{EPSILON}	{ yylval = yytext[0]; add(yytext[0], 0); return EPS; }
{EMPTYSET}	{ yylval = yytext[0]; add(yytext[0], 0); return EMPTY; }
[()|*] 		{ yylval = 999; add(yytext[0], 0); return yytext[0]; }
%%

void
add(const char c, const int alphabetical) {
  unsigned char u = (const unsigned char)c;
  if (alphabetical && !in_alphabet[u]) {
    alphabet[alphabet_size++] = c;
    in_alphabet[u] = c;
  }
  *title_start++ = c;
}//add

int yywrap(void) {
  return 1;
}//yywrap
