#include<stdio.h>
int main(int argc,char *argv[]){
	int i,n;

	n=0;
	for(i=0;argv[1][i]>='0'&&argv[1][i]<='9';++i)
		n=10*n+(argv[1][i]-'0');
	printf("%d\n",n);
}
