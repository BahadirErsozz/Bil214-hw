#include <stdio.h>  
#include <stdbool.h>

int max(int arr[], int size){
	int i;
	int max = arr[0];
	
	for (i = 1; i < size; i++)
		if(arr[i] > max)
			max = arr[i];
	return max;
}	

int min(int arr[], int size){
	int i;
	int min = arr[0];
	
	for (i = 1; i < size; i++)
		if(arr[i] < min)
			min = arr[i];
	return min;
}

int sum(int arr[], int size){
	int i;
	int sum = arr[0];
	
	for (i = 1; i < size; i++)	
		sum += arr[i];
	return sum;
}

double mean(int arr[], int size){
	double sum = 0;
	int i;
	for (i = 0; i < size; i++)	
		sum += arr[i];
	
	double mean = sum / size;

	
	return mean;
}

int product(int arr[], int size){
	int i;
	int product = arr[0];
	
	for (i = 1; i < size; i++)	
		product *= arr[i];
	return product;
}


int main() {  
	int x[20];
	int i = 0;
	char temp, yn;
	bool Running=true;
	
	printf("Welcome,\n");
	
	while (Running==true){
		printf("Please enter the array: ");
		
		do { 
       		scanf("%d%c", &x[i], &temp); 
       		i++; 
    		} while(temp != '\n');
    		
    		printf("Number of elements: %d\n", i);
    		
    		printf("Max: %d\n", max(x, i));
    		printf("Min: %d\n", min(x, i));	
    		printf("Sum: %d\n", sum(x, i));
    		printf("Mean: %f\n", mean(x, i));
    		printf("Product: %d\n", product(x, i));
    		printf("Max difference: %d\n", (max(x, i) - min(x, i)));
    		
    		printf("Do you want to continue? (Y/N)\n");
    		scanf("%c", &yn);
    		if (yn=='N'){
    			Running=false;
    			printf("Exiting program.");
    		}
    		else if (yn=='Y'){
    			i=0;
    			continue;
    		
    		}
    		i=0;
	}

	
	for(int j = 0; j < i; j++) {
     	   printf("%d\n", x[j]);
  	}
	
	return 0;  
}
// while not stopped take the arr as inp then ... if continue == false then stopped =true
 
