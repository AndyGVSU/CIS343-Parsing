/******************************************************************************
ZoomJoyStrong lexer file

Acts as a lexer to read characters as tokens.
Reads shape names, an end-of-line character for statements, integers, floats,
ignores whitespace, and stops the lexer if anything else unidentified has
been found. 

Uses the ZoomJoyStrong parser file to read statements.

@author Anderson Hudson
@version Fall 2018
******************************************************************************/
%{
#include <stdio.h>
#include "zoomjoystrong.tab.h"

int lines = 0;
%}

%option noyywrap

%%
end 		  { return END; }
;		  { return END_STATEMENT; }
point             { return POINT; }
line		  { return LINE; }
circle            { return CIRCLE; }
rectangle         { return RECTANGLE; }
set_color         { return SET_COLOR; }
[ ][0-9]+         { yylval.ival = atoi(yytext); return INT; } 
[ ][0-9]+\.[0-9]* { return FLOAT; }
[ \t\n]+	  { }
.                 {
		    printf("%s\n","Error: Invalid Character '");
                    printf(yytext);
		    printf("' on Line ");
		    printf("%d",lines);
		    exit(1); 
		  }
%%
