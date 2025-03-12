%{
#include "y.tab.h"
%}

%%
[IVXLCDM]+  { yylval.str = strdup(yytext); return ROMAN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
[ \t\n]     { /* Ignore whitespace */ }
.           { printf("Invalid character: %s\n", yytext); return 0; }
%%





