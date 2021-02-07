%{
#include <stdio.h>
#include <math.h>
#include "gpp_interpreter.h"
extern FILE *yyin;

int arr[1000]; 
int val1 = 0, val2 = 0, IDVal = 0, numVal = 0, index = 0, ifVal = 0, elseVal=0, printVal=0, errorVal = 0, exitVal = 0;

%}

%start START
%token IntegerValue
ID OP_PLUS OP_MINUS OP_MULT OP_DIV OP_OP OP_CP OP_OC OP_CC OP_DOUBLEQUOTE KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS 
KW_NIL KW_APPEND KW_CONCAT KW_SET KW_SETQ KW_DEFFUN KW_OPLIST KW_DBLMULT KW_FOR KW_WHILE KW_DEFVAR KW_IF 
KW_EXIT KW_LOAD KW_DISP KW_TRUE KW_FALSE KW_LIST COMMENT


/* RULES */
%% 

START: | INPUT;        

INPUT: 
EXPI { 
    if(!errorVal)
        printf("SYNTAX OK.\n") ;
    if(ifVal==1 && printVal==1 && val2==0 && elseVal==0 && !errorVal){ 
        printf ("\nResult: (" );
        printArr(arr,index);
        printf (")");
        index=0;
        ifVal=0;
        printVal=0;
    }

    else if(val2==1 && printVal==1 && !errorVal){ 
        printf ("\nResult: (" );
        index = val1;
        printArr(arr,index);
        printf (")");
        index=0;
        val2=0;
        ifVal=0;
        printVal=0;
    }
    else if(val2==0 && elseVal==1 && printVal==1 && !errorVal ){
        for(int i= 0; i<index-val1 ; i++){
            arr[i]=arr[val1+i];
        }
        printf ("\nResult: (" );
        index=index-val1;
        printArr(arr,index);
        printf (")");
        index=0;
        elseVal=0;
        printVal=0;
    }
   
    else if (ifVal==0 && printVal==1 && numVal==0 && !errorVal){ 
        printf("\nResult: Nil"); 
        printVal=0;  
    } 
     if(numVal==1 && printVal==1 && !errorVal){
         printf("\nResult: %d\n",$$);
         numVal=0; 
         printVal=0;
    }      
}

| EXPLISTI {
    if(printVal==1 && ifVal==1 && !errorVal){ 
        printf("SYNTAX OK.\n");
        printf ("Result: (" );
        printArr(arr,index);
        printf (")");
        index=0;
        printVal=0;
        ifVal=0;
    }    
}

| EXPB { 
    if (!errorVal)
        printf("SYNTAX OK."); 
    if(printVal==1 && !errorVal){
        printf("\nResult: ");
        if($$ == 1){
            printf ("True");
        }
        else
            printf("False");  
        printVal=0; 
    }      
} 

LISTVALUE: 
KW_OPLIST VALUES OP_CP {  if (val1 == 0 && !errorVal) { val1 = index; }}
| KW_LIST OP_CP ;

VALUES: 
VALUES IntegerValue { arr[index]=$2; index=index+1; }
| IntegerValue  { arr[index]=$1 ; index=index+1; };

EXPI: 
OP_OP OP_PLUS EXPI EXPI OP_CP {$$=$3+$4; printVal=1; numVal=1; }

| OP_OP OP_MINUS EXPI EXPI OP_CP {$$=$3-$4; printVal=1; numVal=1;}

| OP_OP OP_MULT EXPI EXPI OP_CP {$$=$3*$4; printVal=1; numVal=1;}

| OP_OP OP_DIV EXPI EXPI OP_CP {$$=$3/$4; printVal=1; numVal=1;}

| OP_OP KW_DBLMULT EXPI EXPI OP_CP {$$ = pow($3,$4); printVal=1; numVal=1;}

| OP_OP ID EXPLISTI OP_CP { $$= $3; ifVal=1; printVal=1;  }

| OP_OP KW_SET ID EXPI OP_CP { $$ = $4; printVal=1; numVal = 1;}

| OP_OP KW_SET ID OP_CP { $$ = $4; printVal=1; numVal = 1;}

| OP_OP KW_SETQ ID EXPI OP_CP { $$ = $4; printVal=1; numVal = 1;}

| OP_OP KW_SETQ ID OP_CP { $$ = $4; printVal=1; numVal = 1;}

| OP_OP KW_DEFFUN ID IDLIST EXPLISTI OP_CP 

| ID 

| OP_OP KW_LOAD OP_DOUBLEQUOTE ID OP_DOUBLEQUOTE OP_CP

| OP_OP KW_LOAD OP_OC ID OP_CC OP_CP

| OP_OP KW_DISP  OP_DOUBLEQUOTE ID OP_DOUBLEQUOTE  OP_CP

| IntegerValue  {$$=$1;  }

| COMMENT 

| OP_OP KW_IF EXPB EXPLISTI OP_CP {
    printVal=1;
    if($3==1){ 
         ifVal=1; 
    } else{
        ifVal=0;
    } 
}

| OP_OP KW_WHILE EXPB  EXPLISTI OP_CP  
{ 
    printVal=1;
    if($3==1){ 
        ifVal=1; 
    } 
    else {
        ifVal=0;
    } 
}

| OP_OP KW_FOR OP_OP ID EXPI EXPI OP_CP EXPLISTI OP_CP 
{ 
    printVal=1;
    ifVal=1;    
}

| OP_OP KW_DEFVAR ID EXPI OP_CP {  printVal=1; numVal=1; ifVal=0; $$=$4; }

| OP_OP KW_LIST VALUES OP_CP {  printVal=1; ifVal= 1;}

| OP_OP KW_EXIT OP_CP { exitVal = 1; return 0;  }
;

EXPB: 
OP_OP KW_AND EXPB EXPB OP_CP  {$$=($3 && $4);  printVal=1;} 

| OP_OP KW_OR EXPB EXPB OP_CP   {$$=($3 || $4); printVal=1; } 

| OP_OP KW_NOT EXPB  OP_CP  {$$=!$3;  printVal=1;} 

| OP_OP KW_LESS EXPI EXPI OP_CP  {$$=($3 < $4);  printVal=1; } 

| OP_OP KW_EQUAL EXPB EXPB OP_CP  {$$=($3==$4);  printVal=1; } 

|OP_OP KW_EQUAL EXPI EXPI OP_CP  {$$=($3==$4);  printVal=1; } 

| BinaryVal
;

BinaryVal:
 KW_TRUE { $$=1;}

| KW_FALSE   {$$=0; }
;

IDList:
 IDList ID 
| ID
;

EXPLISTI: 
OP_OP KW_CONCAT EXPLISTI EXPLISTI OP_CP 

| OP_OP KW_APPEND EXPI EXPLISTI OP_CP { mAppend(arr,index,$3); index=index+1; }

| LISTVALUE { ifVal=1; printVal=1;};

IDLIST: 
OP_OP IDList OP_CP;

%% 
int main(int argc, char *argv[]){
    FILE *fp; 
    if (argc <= 1){      //for interpreter ,to terminate program write (exit) 
        yyin = stdin; //interpreter is doing lexical analysis.
        while (exitVal==0){
            yyparse(); 
             
        }         
        
    }      
    else{   //for reading file.
        fp = fopen(argv[1],"r");  
        yyin = fp; /* file is read, lexical analysis will be done. */
        while (exitVal==0){
            yyparse(); 
        }   
    }    
    return 0; 
}

int yyerror(const char * ch) { 
    printf("\nSYNTAX_ERROR: Expression not recognized!\n");
    exitVal = 1;
    errorVal = 1; 
} 





