/*******************************************************************************
zoomjoystrong.y - ZoomJoyStrong parser file

Reads text as tokens (as defined by the lexer file) and parses the returned
tokens as statements. Uses the "zoomjoystrong.h" file to draw shapes (a point, 
line, circle, or rectangle) based on
the read statements.

The parser will only take coordinates within the screen width and height, and
will only take colors from 0-255, inclusive.

@author Anderson Hudson
@version Fall 2018
******************************************************************************/
%{
#include <stdio.h>
#include <stdlib.h>
#include "zoomjoystrong.h"

extern int yylex();
extern int yyparse();

//from https://stackoverflow.com/questions/1921539/using-boolean-values-in-c
typedef enum{false, true} bool;

void yyerror(const char* s);
bool checkScreenBounds(int x, int y);
bool checkColorBounds(int r, int g, int b);
%}

%union {
int ival;
}

%token<ival> INT
%token END END_STATEMENT LINE POINT CIRCLE RECTANGLE SET_COLOR FLOAT

%%

list_of_expr:	statement
	|       list_of_expr statement
	;

statement: expr END_STATEMENT
	 ;

expr:		LINE INT INT INT INT {  if (checkScreenBounds($2,$3) &&
					checkScreenBounds($4,$5))
						line($2,$3,$4,$5); }

    	|	POINT INT INT { 	if (checkScreenBounds($2,$3))
						point($2,$3); }

	|	CIRCLE INT INT INT {    if (checkScreenBounds($2,$3))
						circle($2,$3,$4); }

	|	RECTANGLE INT INT INT INT { 	
					if (checkScreenBounds($2,$3) &&
					checkScreenBounds($4,$5))
						rectangle($2,$3,$4,$5); }

	|	SET_COLOR INT INT INT { if (checkColorBounds($2,$3,$4))
						set_color($2,$3,$4);
					}					
	|	END {			exit(0);}
	;

%%

/****************************************************************************** 
checkScreenBounds() - Checks whether the given coordinate is inside the screen's
dimensions. If so, returns true; if not, displays an error and returns false.
int x - given x coordinate
int y - given y coordinate
******************************************************************************/
bool checkScreenBounds(int x, int y) {
	if (x < 0 || x > WIDTH || y < 0 || y > HEIGHT) {
		printf("\nCoordinate out of screen bounds.");
		return false;	
	}
	return true;	
}

/******************************************************************************
checkColorBounds() - Checks whether the given RGB color is valid (all values are
between 0 and 255 inclusive). If so, returns true; if not, displays an error
and returns false. 
int r - given red value
int g - given green value
int b - given blue value
******************************************************************************/
bool checkColorBounds(int r, int g, int b) { 
	if (r > 255 || r < 0 ||
	 g > 255 || g < 0 ||
	 b > 255 || b < 0 ) {
		printf("\nColor value out of bounds [0-255]");
		return false;
	}
	return true;
}

/******************************************************************************
main() - Runs the parser and loads the drawer.
int argc - argument count
char** argv - arguments
******************************************************************************/
int main(int argc,char** argv) {	
	setup();
	yyparse();
	finish();
	
	return 0;
}

/******************************************************************************
yyerror() - Catches parsing errors.
const char* s - error type
******************************************************************************/
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
	finish();
}
