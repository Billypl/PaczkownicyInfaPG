%{
    #include "defs.h"
    #include "x.tab.h"
    #include <stdio.h>
    #include <string.h>
    
    #define V(val, token) {yylval.c = val; return token;}
    #define CHAR_V(val) V(val, CHAR)
    #define S_V(val) V(val, S)
    int comm_beg = 0;
    int tag_beg = 0;
    int pi_beg = 0;
%}

%option yylineno

%x ST_COMMENT ST_PI ST_TAG

IDENT [:_a-zA-Z][:_a-zA-Z\-0-9]*
%%

"<!--" {
    comm_beg = yylineno;
    BEGIN(ST_COMMENT);
}

<ST_COMMENT>.|\n ;

<ST_COMMENT>[^-]"-->" {
    BEGIN(INITIAL);
}

"<?"{IDENT} {
    pi_beg = yylineno;
    BEGIN(ST_PI);
    strcpy(yylval.s, yytext + 2);
    return PI_TAG_BEG;
}

<ST_PI>.|\n ;

<ST_PI>"?>" {
    BEGIN(INITIAL);
    return PI_TAG_END;
}

"<"{IDENT} {
    tag_beg = yylineno;
    BEGIN(ST_TAG);
    strcpy(yylval.s, yytext + 1);
    return STAG_BEG;
}

"</"{IDENT} {
    tag_beg = yylineno;
    BEGIN(ST_TAG);
    strcpy(yylval.s, yytext + 2);
    return ETAG_BEG;
}

<ST_TAG>">" {
    BEGIN(INITIAL);
    return TAG_END;
}

<ST_TAG>"/>" {
    BEGIN(INITIAL);
    return ETAG_END;
}

<ST_TAG>.|\n ;

"&lt;" CHAR_V('<');
"&gt;" CHAR_V('>');
"&amp;" CHAR_V('&');
"&apos;" CHAR_V('\'');
"&quote;" CHAR_V('"');

^[\n\t]* ;
\r ;
\n return yytext[0];
" "|\t S_V(yytext[0]);
. CHAR_V(yytext[0]);
%% 

int yywrap( void ){ 

  switch(YY_START){
    case ST_COMMENT:
        printf("lexical error: unfinished comment starting at line %d\n", comm_beg);
        break;
    case ST_TAG:
        printf("lexical error: unfinished tag starting at line %d\n", tag_beg);
        break;
    case ST_PI:
        printf("lexical error: processing instruction starting at line %d\n", pi_beg);
        break;
  }

  return 1;
}

