/* Bahadir Ersoz 201101022  */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int lineCounter(char *fileName){
    FILE *file = fopen(fileName, "r");
    int linecount = 0;
    int c;
    while((c=fgetc(file)) != EOF )
        if(c == '\n')
            linecount++;
    fclose(file);
    return linecount;

}
void sameFile(FILE *inpFile, FILE *outFile){
	
	char c[9999];
	
	while (fgets(c,9999,inpFile) != NULL) {
		fprintf(outFile, "%s", c);  
	}	
}

void reverseFile(FILE *inpFile, FILE *outFile){
		
	char c[9999];
	
	if(fgets(c,9999, inpFile) == NULL){
		return;	
	}
	else{
		reverseFile(inpFile, outFile);
		fprintf(outFile, "%s", c);
	}
	return;	
	
}

void switchEven(FILE *inpFile, FILE *outFile){
	char c[9999];
	char c2[9999];
	if(fgets(c,9999, inpFile) == NULL)
		return;
	else{
		if(fgets(c2,9999, inpFile) == NULL)
			fprintf(outFile, "%s", c);
		else{
			fprintf(outFile, "%s%s", c2, c);
			switchEven(inpFile, outFile);
		}
	}
}

// 
void alphabetical(char *name, FILE *inpFile, FILE *outFile){
	int lineCount = lineCounter(name);
	char c[9999];
	char temp[9999];
	int counter = 0;
	char content[lineCount][9999];
	while(fgets(c,9999, inpFile) != NULL){
		strcpy(content[counter], c);
		counter++;
	}
	
	for(int i = 1; i <lineCount; i++){
		for(int j= 1; j <lineCount;j++){
			if(strcmp(content[j-1], content[j]) > 0){
				strcpy(temp, content[j-1]);
				strcpy(content[j-1], content[j]);
				strcpy(content[j], temp);
			}
		}
	
	}
	for(int k = 0; k < lineCount; k++)
		fprintf(outFile, "%s", content[k]);
	
}







int main(int argc, char *argv[]){
	
		
	int option;	
	char *fileInput = NULL; 
	char *fileOutput = NULL;
	char operand;

	while((option = getopt(argc, argv, "i:o:s:")) != -1){ 
        	switch(option){
       
          	case 'i':
          		fileInput = optarg;
         		break;
        	 case 'o':
			fileOutput = optarg;
         		break;
         	case 's': 
			operand = *optarg;
           		break;
            		printf("option needs a value\n");
            		break;
         	case '?': 
            		printf("unknown option: %c\n", optopt);
            		break;
     	 	}
   	}
   	
   	FILE *in;
   	in = fopen(fileInput, "r");	
   	if(in == NULL){
   		printf("Couldn't load the input file\n");
   		return 1;
   	}
   	FILE *out;
   	out = fopen(fileOutput, "w");
  	
  	if(operand == '0')
  		sameFile(in, out);
 	else if(operand == '2')
  		reverseFile(in, out);
	else if(operand == '3')
		switchEven(in, out);
	else if(operand == '1')
		alphabetical(fileInput,in, out);
	else 
		printf("Unvalid operation\n");
	fclose(in);
	fclose(out);
	return 0;
}
