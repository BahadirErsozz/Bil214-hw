#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
	
	int option;
	char alphabet[52] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	int letterCountR[26] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int letterCountC[26] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	
	char fileR[20]; //arttır
	char fileC[20];
	char fileP[20];

   while((option = getopt(argc, argv, "r:c:p:")) != -1){ 
      switch(option){
       
         case 'p':
         	strcpy(fileP, optarg);
         	
         	break;
         case 'r':
         	strcpy(fileR, optarg);
         	
         	break;
         case 'c': 
            	strcpy(fileC, optarg);
            	
           	break;
         case ':':
            printf("option needs a value\n");
            break;
         case '?': 
            printf("unknown option: %c\n", optopt);
            break;
      }
   }
	
	
	
	char ch;
	FILE *fp, *fp2, *fp3;
	
	fp = fopen(fileR, "r");
	fp3 = fopen(fileC, "r");
	
	if(fp == NULL)
		printf("%s dosyası bulunamadı.\n", fileR);
	if(fp3 == NULL)   	
		printf("%s dosyası bulunamadı.\n", fileC);
   	if (fp == NULL || fp3 == NULL){
        	exit(0);
   	}
	while((ch = fgetc(fp)) != EOF){
        	for(int i = 0; i < 52; i++){
        		if(alphabet[i] == ch){
        			letterCountR[i % 26]++;
        		}
        		
        	}
	}
        fclose(fp);
	
	 
	
	while((ch = fgetc(fp3)) != EOF){
        	for(int i = 0; i < 52; i++){
        		if(alphabet[i] == ch){
        			letterCountC[i % 26]++;
        		}
        		
        	}
	}
	fclose(fp3);
	
	
	int maxElementR=0, maxElementC=0, minElementR=0, minElementC=0;
	for(int j = 0; j < 26; j++){
		if(letterCountC[maxElementC] < letterCountC[j])
			maxElementC = j;
		if(letterCountC[minElementC] > letterCountC[j])
			minElementC = j;
		if(letterCountR[maxElementR] < letterCountR[j])
			maxElementR = j;
		if(letterCountR[minElementR] > letterCountR[j])
			minElementR = j;
		
        
        	
        		
        }
	


	
	FILE *f, *f1, *f2;
	fp2 = fopen(fileC, "r"); 
   	char asd[20];
   	strcpy(asd, fileP);
   	if((maxElementR - maxElementC + 26)%26 == (minElementR - minElementC + 26)%26){
   		f = fopen(fileP, "w");
   		printf("Kayırma mikatrı %d olarak tespit edilmiştir.\n", (maxElementR - maxElementC + 26)%26);
   		printf("Çözümlenmiş metin %s dosyasına yazılmıştır.\n", fileP);
   	}	
   	else{
   		
   		f1 = fopen(strcat(asd, "_0"), "w");
   		f2 = fopen(strcat(fileP, "_1"), "w"); 
   		printf("Kayırma miktarı %d (en sık harf) ve %d (en seyrek harf) olarak tespit edilmiştir.\n", (maxElementR - maxElementC +26) % 26 , (minElementR - minElementC +26) % 26);
   		printf("Çözümlenmiş metin %s ve %s dosyalarına yazılmıştır.\n", asd, fileP);
   	}
   	
   	if (fp2 == NULL){
        	printf("%s dosyası bulunamadı.\n", fileC);
        	exit(0);
   	}
	while((ch = fgetc(fp2)) != EOF){
        	if((maxElementR - maxElementC + 26)%26 == (minElementR - minElementC + 26)%26){
        		fprintf(f,"%c", alphabet[(ch - 97 + maxElementR - maxElementC +26) % 26]);		
        		
        		}
        	else{
        		
			fprintf(f1,"%c", alphabet[(ch - 97 + maxElementR - maxElementC +26) % 26]);
			
			
        		fprintf(f2,"%c", alphabet[(ch - 97 + minElementR - minElementC +26) % 26]);
        		
        		
        	}
	}
	if((maxElementR - maxElementC + 26)%26 == (minElementR - minElementC + 26)%26)
		fclose(f);
	else{
		fclose(f1);
		fclose(f2);
	}
	
	fclose(fp2);







	
	return 0;
}
