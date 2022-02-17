#include <stdio.h>  
#include <stdbool.h>
#include <string.h>
#include <ctype.h>
int main() {  
	char str[15];
	char yn, temp;
	bool running = true;
	printf("Welcome,\n");
	
	while(running==true){
		printf("Please enter a string: ");
		scanf("%s", str);  
		scanf("%c", &temp);
		printf("Original: %s\n", str);
		printf("Lowercase: ");
		for (size_t i = 0; i < strlen(str); ++i) {
        		printf("%c", tolower((unsigned char) str[i]));
    		}
    		printf("\n"); 
	
		printf("Uppercase: ");
		for (size_t i = 0; i < strlen(str); ++i) {
        		printf("%c", toupper((unsigned char) str[i]));
    		}
    		printf("\n"); 

		printf("Alternated case: ");
		for (size_t i = 0; i < strlen(str); ++i) {
			if (str[i] == toupper((unsigned char) str[i]) )
        			printf("%c", tolower((unsigned char) str[i]));
        		else
        			printf("%c", toupper((unsigned char) str[i]));
    		}
    		printf("\n");
    			
    		printf("Duplicated: ");
    		for (size_t i = 0; i < strlen(str); ++i) {
			if (str[i] == toupper((unsigned char) str[i]) )
        			printf("%c%c", str[i], str[i]);
        		else
        			printf("%c", str[i]);
    		}
    		printf("\n");
    		
		printf("ASCII: ");
    		for (size_t i = 0; i < strlen(str); ++i) {
			printf("%03d ", str[i]);
    		}
    		printf("\n");
	
		printf("Do you want to continue? (Y/N)\n");
		scanf("%c", &yn);
    		if (yn=='N'){
    			running=false;
    			printf("Exiting program.");
    		}
    		else if (yn=='Y'){
    			str[0]='\0';
    			continue;
    		
    		}
    		str[0]='\0';
	}
	
	
	
	return 0;  
}
//
