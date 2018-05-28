typedef union					/*定义yylval的格式*/
{	/*属于create语法树的类型*/
	char * yych;				//字面量
	struct Createfieldsdef	*cfdef_var;	//字段定义
	struct Createstruct	*cs_var;	//整个create语句
} YYSTYPE;
#define	CREATE	257
#define	TABLE	258
#define	ID	259
#define	CHAR	260
#define	NUMBER	261
#define	INT	262
#define	CONST_STR	263


extern YYSTYPE yylval;
