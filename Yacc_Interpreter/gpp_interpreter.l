%{ 
/* DEFINITION PART */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "y.tab.h" 
%} 

COMMENT ";".*
VAL [1-9][0-9]*|"0"
ID [a-zA-Z][a-zA-Z0-9]*
ID_F [a-zA-Z_][a-z.A-Z0-9_]*
ID_F2 [a-zA-Z_][a-z.A-Z0-9++_]*
FLOAT_P [0-9]+"."[0-9]*
EXIT "exit"

%%
	/* RULES PART */
^\n                     {exit(1);}
" "|"\t" { } 
"\n" {printf("%s\n",yytext); return 0; }

{EXIT} { return KW_EXIT; }
"+" { return OP_PLUS;}
"-" { return OP_MINUS;}
"/" { return OP_DIV;}
"*" { return OP_MULT;}
"'(" { return KW_OPLIST;}
"**" {return KW_DBLMULT;}
"and" { return KW_AND  ;}
"or" { return KW_OR ;}
"not" { return  KW_NOT ;}
"equal" { return KW_EQUAL ;} 
"less" { return KW_LESS ;}
"nil" { return KW_NIL ;}
"list" { return KW_LIST ;}
"append" {return KW_APPEND ;}
"concat" {return KW_CONCAT ;}
"set" { return KW_SET ;}
"setq" { return KW_SETQ ;}
"deffun" { return KW_DEFFUN ;}
"for" { return KW_FOR; }
"while" { return KW_WHILE; }
"defvar" { return KW_DEFVAR; }
"if" { return KW_IF; }
"load" { return KW_LOAD; }
"disp" { return KW_DISP; }
"true" { return KW_TRUE; }
"false" { return KW_FALSE; }
"“"		{return OP_OC;}
"”" 		{return OP_CC;}
"\(" { return OP_OP;}
"\)" { return OP_CP;} 
"\"" {return OP_DOUBLEQUOTE;}
{ID}|{ID_F}|{ID_F2} { return ID;}
{COMMENT} {return COMMENT;}


{VAL}|{FLOAT_P} {
    yylval=atoi(yytext); 
    return IntegerValue; 
}

[0-9][0-9a-zA-Z]*	 	  	  {printf("SYNTAX_ERROR: Expression not recognized!\n"); return 0;}
.	 	  	  				  {}


%% 

int yywrap() 
{ 
return 1; 
} 
