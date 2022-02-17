#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>


struct movie{
	int id;
	char *name;
	char *producer;
	int year;
	char *genre;

};

void printMovie(struct movie m){
	
	printf("%d, %s, %s, %d, %s\n", m.id, m.name, m.producer, m.year, m.genre);
	
}



int main(){
	struct movie movies[100];
	
	char yearCurrent[4];
	int counter = 0, idCounter = 1;
	char nameCurrent[100][100];	
	char producerCurrent[100][100];
	char genreCurrent[100][100];
	
	char c[111];
	char *walker;
	FILE *inpFile = fopen("movies.csv", "r");
	if(inpFile == NULL){
   		printf("Couldn't load the input file\n");
   		return 1;
   	}
	while(fgets(c,100, inpFile) != NULL){
		// adding id
		walker = strdup(c);
		while(*walker != ','){
		
			// checking if the string has a comma in it.
			if(*walker == '"'){
				nameCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
				while(*walker != '"'){
					nameCurrent[idCounter - 1][counter] = *walker;
					counter++;
		
					walker = walker + 1;
				}
				nameCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
								
			}
			else{	
				nameCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;
			}
		}
		
		
		counter = 0;
		
		walker = walker +1;
		while(*walker != ','){
			// checking if the string has a comma in it.
			if(*walker == '"'){
				producerCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
				while(*walker != '"'){
					producerCurrent[idCounter - 1][counter] = *walker;
					counter++;
		
					walker = walker + 1;
				}
				producerCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
								
			}
			else{	
				producerCurrent[idCounter - 1][counter] = *walker;
				counter++;
	
				walker = walker + 1;
			}
		}
	
		counter = 0;
		walker = walker +1;
		while(*walker != ','){
			
			yearCurrent[counter] = *walker;
			
			walker = walker + 1;
			counter++;
		}
		counter = 0;
		
		// adding the year

		
		walker = walker +1;
		while(*walker != '\n'){
			// checking if the string has a comma in it.
			if(*walker == '"'){
				genreCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
				while(*walker != '"'){
					genreCurrent[idCounter - 1][counter] = *walker;
					counter++;
		
					walker = walker + 1;
				}
				genreCurrent[idCounter - 1][counter] = *walker;
				counter++;
		
				walker = walker + 1;		
								
			}
			else{	
				genreCurrent[idCounter - 1][counter] = *walker;
				counter++;
				
				walker = walker + 1;
			}
		}
		counter = 0;
		
		struct movie mv = {
			idCounter,
			nameCurrent[idCounter - 1],
			producerCurrent[idCounter - 1],
			atoi(yearCurrent),
			genreCurrent[idCounter - 1]
	
		};
		
		movies[idCounter - 1] = mv;
		
		idCounter++;
		
			
	}
	
	int running = 1, properCommand = 1, idChange = 0, counter2 = 0, walker2 = 0;
	char command[20], searchFor[200], searchType[200], operation[200], searchName[200];
	char nameNew[100], producerNew[100], genreNew[100], infoNew[200], yearNew[100];
	
	while(running == 1){
		if(properCommand == 1){
			printf("Please enter a command: ");
			scanf(" %[^\n]", command);
		}
		else{
			printf("Please enter a valid command: ");
			scanf(" %[^\n]", command);
		}
		if(strcmp(command, "print") == 0){
			properCommand = 1;
			for(int i = 0; i < idCounter - 1; i++)
				printMovie(movies[i]);
		}
		else if(strcmp(command, "update") == 0){
			properCommand = 1;
			printf("ID: ");
			scanf(" %d", &idChange);
			printf("New info: ");
			scanf(" %[^\n]", infoNew);
			
			while(infoNew[walker2] != ','){
				nameNew[counter2] = infoNew[walker2];
				counter2++;
				walker2++;
			}
		
			if(strcmp(nameNew, "") != 0)
				strcpy(movies[idChange - 1].name,nameNew);
			walker2++;
			counter2 = 0;
			while(infoNew[walker2] != ','){
				producerNew[counter2] = infoNew[walker2];
				counter2++;
				walker2++;
			}
			if(strcmp(producerNew, " ") != 0)
				strcpy(movies[idChange - 1].producer,producerNew);
			walker2++;
			counter2 = 0;
			while(infoNew[walker2] != ','){
				yearNew[counter2] = infoNew[walker2];
				counter2++;
				walker2++;
			}
			
			if(strcmp(yearNew, " ") != 0)
				movies[idChange - 1].year = atoi(yearNew);
			walker2++;
			counter2 = 0;
			while(infoNew[walker2] != '\0'){
				genreNew[counter2] = infoNew[walker2];
				counter2++;
				walker2++;
			}
			if(strcmp(genreNew, " ") != 0)
				strcpy(movies[idChange - 1].genre,genreNew);
		

			memset(yearNew,0,strlen(yearNew));
			memset(genreNew,0,strlen(genreNew));
			memset(nameNew,0,strlen(nameNew));
			memset(producerNew,0,strlen(producerNew));
			memset(infoNew,0,strlen(infoNew));
			walker2 = 0;
			counter2 = 0;
		
		}
		else if(strcmp(command, "search") == 0){
			properCommand = 1;
			memset(searchFor,0,strlen(searchFor));
			memset(searchType,0,strlen(searchType));
			memset(operation,0,strlen(operation));
			memset(searchName,0,strlen(searchName));
			printf("Search condition: ");
			scanf(" %[^\n]",searchFor);
			while(searchFor[walker2] != ' '){
				searchType[counter2] = searchFor[walker2];
			
				walker2++;
				counter2++;
			}
			
			counter2 = 0;
			walker2++;
			while(searchFor[walker2] != ' '){
				operation[counter2] = searchFor[walker2];
				walker2++;
				counter2++;
			}
			counter2 = 0;
			walker2++;
			while(searchFor[walker2 + 1] != '\0'){
				searchName[counter2] = searchFor[walker2];
				walker2++;
				counter2++;
			}
		
			
			if(strcmp(searchType,"genre") == 0){
				
				if(strcmp(operation, "==") == 0){
				
					for(int j = 0; j < idCounter - 1;j++) {
					//strcmp calismiyor adam akilli
						if(strcmp(movies[j].genre, searchName) == 0){
							printMovie(movies[j]);
							
						}
					}
				}
				else if(strcmp(operation, "!=") == 0){
					for(int j = 0; j < idCounter - 1;j++)
						if(strcmp(movies[j].genre, searchName) != 0)
							printMovie(movies[j]);
				}
			
			}
			if(strcmp(searchType, "year") == 0){
				if(strcmp(operation, "==") == 0){
					for(int j = 0; j < idCounter - 1;j++)
						if(movies[j].year == atoi(searchName))
							printMovie(movies[j]);
				}
				else if(strcmp(operation, "!=") == 0){
					for(int j = 0; j < idCounter - 1;j++)
						if(movies[j].year != atoi(searchName))
							printMovie(movies[j]);
				}
				else if(strcmp(operation, "<") == 0){
					for(int j = 0; j < idCounter - 1;j++)
						if(movies[j].year < atoi(searchName))
							printMovie(movies[j]);
				}
				else if(strcmp(operation, ">") == 0){
					for(int j = 0; j < idCounter - 1;j++)
						if(movies[j].year > atoi(searchName))
							printMovie(movies[j]);
				}
			}
			counter2 = 0;
			
			walker2 = 0;
			memset(searchFor,0,strlen(searchFor));
			memset(searchType,0,strlen(searchType));
			memset(operation,0,strlen(operation));
			memset(searchName,0,strlen(searchName));
		}
		else if(strcmp(command, "exit") == 0)
			running = 0;
		else
			properCommand = 0;
		memset(command,0,strlen(command));
	}


	fclose(inpFile);
	return 0;	
}
