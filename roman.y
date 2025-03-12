%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
int romanToDecimal(char *roman);
void decimalToRoman(int num, char *result);
void decimalToBinary(int num, char *result);

%}

%union {
    int num;
    char *str;
}

%token PLUS MINUS
%token <str> ROMAN
%type <num> expr term

%%

expr:
      term PLUS term  { 
          int result = $1 + $3;
          char roman[50], binary[50];
          decimalToRoman(result, roman);
          decimalToBinary(result, binary);
          printf("Decimal: %d\nRoman: %s\nBinary: %s\n", result, roman, binary);
          $$ = result;
      }
    | term MINUS term {
          int result = $1 - $3;
          if (result <= 0) {
              printf("Invalid: Roman numerals can't represent zero or negative numbers.\n");
              $$ = 0;
          } else {
              char roman[50], binary[50];
              decimalToRoman(result, roman);
              decimalToBinary(result, binary);
              printf("Decimal: %d\nRoman: %s\nBinary: %s\n", result, roman, binary);
              $$ = result;
          }
      }
    ;

term: 
      ROMAN { $$ = romanToDecimal($1); free($1); }
    ;

%%

int romanToDecimal(char *roman) {
    int num = 0;
    while (*roman) {
        if (strncmp(roman, "CM", 2) == 0) { num += 900; roman += 2; }
        else if (strncmp(roman, "CD", 2) == 0) { num += 400; roman += 2; }
        else if (strncmp(roman, "XC", 2) == 0) { num += 90; roman += 2; }
        else if (strncmp(roman, "XL", 2) == 0) { num += 40; roman += 2; }
        else if (strncmp(roman, "IX", 2) == 0) { num += 9; roman += 2; }
        else if (strncmp(roman, "IV", 2) == 0) { num += 4; roman += 2; }
        else if (*roman == 'M') { num += 1000; roman++; }
        else if (*roman == 'D') { num += 500; roman++; }
        else if (*roman == 'C') { num += 100; roman++; }
        else if (*roman == 'L') { num += 50; roman++; }
        else if (*roman == 'X') { num += 10; roman++; }
        else if (*roman == 'V') { num += 5; roman++; }
        else if (*roman == 'I') { num += 1; roman++; }
        else return -1;
    }
    return num;
}

void decimalToRoman(int num, char *result) {
    struct { int value; char *symbol; } roman[] = {
        {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"},
        {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
        {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}
    };
    result[0] = '\0';
    for (int i = 0; i < 13; i++) {
        while (num >= roman[i].value) {
            strcat(result, roman[i].symbol);
            num -= roman[i].value;
        }
    }
}

void decimalToBinary(int num, char *result) {
    int i = 0;
    char temp[50];
    while (num > 0) {
        temp[i++] = (num % 2) + '0';
        num /= 2;
    }
    temp[i] = '\0';

    int len = strlen(temp);
    for (int j = 0; j < len; j++) {
        result[j] = temp[len - 1 - j];
    }
    result[len] = '\0';
}

int main() {
    printf("Enter Roman numeral expression (e.g., 'X + V' or 'IX - III'):\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

