#include <stdio.h>
#include <stdbool.h>

void add_index(int *a, int value, int index){
	
	int temp, counter = 0, temp2;
	while(*(a - 1) != -1){
		if(counter == index){
			temp = *a;  
			*a = value;
		}
		if (counter > index){
			temp2 = *a;
			*a = temp;
			temp = temp2;
		}
		printf("%d ", *(a));
		
		a = a + 1;
		counter++;
	}
	printf("\n");
}
int main(){
	int x[100] = {5,3,56,8,0,-1};
	int k = 6, value, index, i = 0;
	char yn;
	bool Running=true;
	
	printf("Welcome,\n");
	printf("The array: ");
	for(int j = 0; j < k - 1; j++)
		printf("%d ", x[j]);
	printf("%d\n", x[k-1]);		
		 
	
	int *pointer = x;
	while (Running==true){
    		printf("Enter a value: ");
    		scanf(" %d", &value);
    		printf("Enter an index: ");
    		scanf(" %d", &index);
    		printf("The new array: ");
    		add_index(x, value, index);
    		printf("Do you want to continue? (Y/N)\n");
    		scanf(" %c", &yn);
    		
    		if (yn=='N'){
    			Running=false;
    			printf("Exiting program.\n");
    		}
    		else if (yn=='Y'){
    			i=0;
    		}
    		i=0;
	}
	return 0; 
}


