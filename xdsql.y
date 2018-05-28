%{
#include<malloc.h>

#define LOG 1

//----------------------------------------------
enum TYPE {T_INT, T_CHAR};		//字段可用类型
struct	Createstruct{			/*create语法树根节点*/
	char	*table;				//基本表名称
	struct Createfieldsdef	*fdef;	//字段定义
}*createroot;
struct	Createfieldsdef{	/*create语句中的字段定义*/
	char		*field;		//字段名称
	enum TYPE	type;		//字段类型
	int			length;		//字段长度
	struct  Createfieldsdef   *next_fdef;	//下一字段
}*createfields;
void print_create(){
	printf("%s\n", createroot->table);
	struct Createfieldsdef* p = createfields;
	while(p != NULL){
		printf("%s,\t %d,\t %d\n",p->field, p->length, p->type);
		p = p->next_fdef;
	}
}
%}
//----------------------------------------------
%union					/*定义yylval的格式*/
{	/*属于create语法树的类型*/
	char * yych;				//字面量
	struct Createfieldsdef	*cfdef_var;	//字段定义
	struct Createstruct	*cs_var;	//整个create语句
}

/*create语句中涉及的符号*/
%token  <yych>	CREATE TABLE ID CHAR NUMBER INT CONST_STR
%type	<yych>	table field	
%type	<cfdef_var>	fieldsdefinition field_type type
%type	<cs_var>	createsql
%%

//----------------------------------------------

createsql: CREATE TABLE table '(' fieldsdefinition ')' ';' {
	createroot = malloc(sizeof(struct Createstruct));
	createroot->table = $3;
	/*
	struct Createfieldsdef *p, *pre, *next;
	p  = createfields;
	pre = NULL;
	while(p != NULL){
		next = p->next_fdef;
		p->next_fdef = pre;
		pre = p;
		createfields = p;
		p = next;
	}
	createroot->fdef = createfields;
	*/
	if(LOG) printf("createsql\n");
	print_create();
}
table: ID {
	$$ = $1;
	if(LOG) printf("table %s\n", $$);
}
fieldsdefinition: field_type {
	$1->next_fdef = NULL;
	$$ = $1;
}
 | field_type ',' fieldsdefinition {
	$1->next_fdef = $3;
	createfields = $1;
	$$ = $1;
}
field_type: field type {
	$2->field = $1;
	$$ = $2;
	if(LOG) printf("field_type %s,%d,%d\n", $$->field, $$->length, $$->type);
}
field: ID {
	$$ = $1;
	if(LOG) printf("field %s\n", $1);
}
type: CHAR '(' NUMBER ')'  {
	struct Createfieldsdef* p = malloc(sizeof(struct Createfieldsdef));
	p->type = T_CHAR;
	p->length = atoi($3);
	$$ = p;
	if(LOG) printf("type CHAR(%s)\n", $3);
}
	| INT {
	struct Createfieldsdef* p = malloc(sizeof(struct Createfieldsdef));
	p->type = T_INT;
	p->length = 0;
	$$ = p;
	if(LOG) printf("type INT\n");
}

%%
int main(){
	yyparse();
	return 0;
}
int yyerror(char* msg){
	printf("Error: %s\n", msg);
}
