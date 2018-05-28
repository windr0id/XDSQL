%{
#include"xdsql.tab.h"

#include<stdio.h>
#include<string.h>

%}

id [A-Za-z][A-Za-z0-9_]*
number [0-9]+
const_str '.*'

%%
CREATE	{return CREATE;}
TABLE	{return TABLE;}
CHAR	{return CHAR;}
INT		{return INT;}
{id} {
	yylval.yych = strdup(yytext);
	return ID;
}
{number} {
	yylval.yych = strdup(yytext);
	return NUMBER;
}
{const_str} {
	char* p = malloc(strlen(yytext)-1);
	strncpy(p, yytext+1, strlen(yytext)-2);
	yylval.yych = p;
	printf("CONST_STR: %s\n", p);
	return CONST_STR;
}

"="		|
">"		|
"<"		|
"!="	|
";"		|
"("		|
")"		|
","		{return yytext[0]; }

%%
int yywrap(){
	return 1;
}
