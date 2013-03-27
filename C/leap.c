#include<stdio.h>
#include<stdlib.h>
main(int argc,char *argv[]){
	int year;
	year=atoi(argv[1]);
	if(year%4==0 && year%100!=0 || year%400==0)
		printf("%d is a leap year\n",year);
	else
		printf("%d is not a leap year\n",year);
}
