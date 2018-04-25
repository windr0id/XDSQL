%{
#include"xdsql.tab.h"

#include<stdio.h>
#include<string.h>
extern int yylval;
%}
char [A-Za-z]
num [0-9]
eq [=]
name {char}+
age {num}+
%%
{name} {
	yylval=(int)strdup(yytext);
	return NAME;
}
{eq} {
	return EQ;
}
{age} {
	yylval=(int)strdup(yytext);
	return AGE;
}
%%
int yywrap(){
	return 1;
}
