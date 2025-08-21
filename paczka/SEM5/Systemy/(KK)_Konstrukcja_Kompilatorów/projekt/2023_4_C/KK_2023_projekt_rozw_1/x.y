%{
#define IDENT_LENGTH 2
#define LINE_WIDTH 55

#include <stdio.h>
#include <string.h>
#include "defs.h"
#include "x.tab.h"
int yylex(void);
int yyerror(const char *txt);
 
void found( const char *nonterminal, const char *value );
void indent(int nesting_lvl);
void strrev(char* str);

int level = 0;
int pos = 0;

char current_word[MAX_STR_LEN] = { 0 };
int current_word_len = 0;

int first_word = 1;
%}

%union {
	char s[ MAX_STR_LEN + 1 ]; 
    char c;
}

%token<s> PI_TAG_BEG STAG_BEG ETAG_BEG
%token<c> CHAR S
%token PI_TAG_END TAG_END ETAG_END
%type<s> START_TAG END_TAG WORD

%%
DOCUMENT: INTRO ELEMENT FOLLOWING_ENDLS ;

INTRO: INTRO INTRO_ENTRY | INTRO_ENTRY ;
INTRO_ENTRY: '\n' | PI

FOLLOWING_ENDLS: FOLLOWING_ENDLS '\n' | /* empty */; 

PI: PI_TAG_BEG PI_TAG_END {indent(level); printf("pi~%s", $1);};

ELEMENT: ETAG | TAG_PAIR  ;
ETAG: STAG_BEG ETAG_END {
	indent(level);
	printf("etag~%s", $1);
};

TAG_PAIR: START_TAG CONTENT END_TAG { 
	if(strcmp($1, $3)){
		char error_msg[MAX_STR_LEN];
		sprintf(error_msg, "expected </%s> to match <%s>", $3, $1);
		yyerror(error_msg);
	}
};

START_TAG: STAG_BEG TAG_END { 
	indent(level++);
	printf("tag~%s", $1);
	pos += strlen($1) + 4;
	strcpy($$, $1); 
};

END_TAG: ETAG_BEG TAG_END { 
	level--;
	strcpy($$, $1); 
};

CONTENT: CONTENT CONTENT_ENTRY | /* empty */;

CONTENT_ENTRY: '\n' 
| ELEMENT {first_word = 1; }
| S 
| WORD {
	current_word[current_word_len] = 0;
	if(first_word || current_word_len + pos + 1> LINE_WIDTH){
		indent(level);
	}
	pos += current_word_len + 1;
	strrev(current_word);
	printf("%s ", current_word);
	first_word = 0;
	current_word_len = 0;
};

WORD: CHAR WORD {
	current_word[current_word_len++] = $1;
} | CHAR {
	current_word[current_word_len++] = $1;
};

%%

#define HEADER_LEN 12
int main( void ){
	char header[MAX_STR_LEN] = {0};
	
	for(int i = 0; i < LINE_WIDTH; i++){
		header[i] = '-';
	}

	strncpy(header + (LINE_WIDTH - HEADER_LEN)/2, "XML DOCUMENT", HEADER_LEN);
	printf("%s", header);
	return yyparse();
}

int yyerror( const char *txt ){
	printf( "\nsyntax error: %s", txt );
    return 0;
}

void indent(int nesting_lvl){
	char indents[MAX_STR_LEN] = { 0 };
	for(int i = 0; i < nesting_lvl * IDENT_LENGTH; i++){
		indents[i] = ' ';
	}	
	pos = nesting_lvl * IDENT_LENGTH;
	printf("\n%s", indents);
}

void strrev(char* str){
    // if the string is empty
    if (!str) {
        return;
    }
    // pointer to start and end at the string
    int i = 0;
    int j = strlen(str) - 1;
 
    // reversing string
    while (i < j) {
        char c = str[i];
        str[i] = str[j];
        str[j] = c;
        i++;
        j--;
    }
}
