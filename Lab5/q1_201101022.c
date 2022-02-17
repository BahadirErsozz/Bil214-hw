#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int main(){
	bool finished = false;
	char strArr[10][20];
	char strSortedArr[10][20];
	char temp[20]; 
	int counter = 0;
	printf("Welcome,\n");
	while (!finished){
		printf("Enter a string: ");
		scanf("%s", temp);
		if (strcmp("sort", temp) == 0){
			finished = true;
		}
		else{ 
			strcpy(strArr[counter], temp);
			counter = counter + 1;
		} 	
	}
	int toDelete;
	char smallest[20];
	printf("The sorted strings:\n");
	for (int i = 0; i < counter; i++){
		strcpy(smallest, strArr[0]);
		toDelete = 0; 
		for (int j = 1; j < counter; j++){
			if(strcmp(strArr[j], smallest) < 0){
				strcpy(smallest, strArr[j]);
				toDelete = j;
			}
		}
		strcpy(strArr[toDelete], "~~~~~~~~~~~~~~~~~~~");
		printf("%s\n", smallest);
	}
	printf("Exiting program.\n");
	
	return 0;
}
