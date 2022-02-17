#include <stdio.h>



char board[6][7] = {"-------","-------","-------","-------","-------","-------"};
int turn = 1;
int isRunning = 1;

void gameFinished(int row, int col, int player){
	char b[2] = "RY"; 
	char a;
	// sol
	if(board[row][col - 3] != '\0')
		if(board[row][col - 1] == b[player] && board[row][col - 2] == b[player] && board[row][col - 3] == b[player])
			isRunning = 0;
	// sag
	if(board[row][col + 3] != '\0')
		if(board[row][col + 1] == b[player] && board[row][col + 2] == b[player] && board[row][col + 3] == b[player])
			isRunning = 0;
	// ust
	if(board[row + 3][col] != '\0')
		if(board[row + 1][col] == b[player] && board[row + 2][col] == b[player] && board[row + 3][col] == b[player])
			isRunning = 0;
	// alt
	if(board[row - 3][col] != '\0')
		if(board[row - 1][col] == b[player] && board[row - 2][col] == b[player] && board[row - 3][col] == b[player])
			isRunning = 0;
	// sol ust		
	if(board[row - 3][col + 3] != '\0')
		if(board[row - 1][col + 1] == b[player] && board[row - 2][col + 2] == b[player] && board[row - 3][col + 3] == b[player])
			isRunning = 0;
			
	// sag ust		
	if(board[row + 3][col + 3] != '\0')
		if(board[row + 1][col + 1] == b[player] && board[row + 2][col + 2] == b[player] && board[row + 3][col + 3] == b[player])
			isRunning = 0;
			
	// sag alt		
	if(board[row + 3][col - 3] != '\0')
		if(board[row + 1][col - 1] == b[player] && board[row + 2][col - 2] == b[player] && board[row + 3][col - 3] == b[player])
			isRunning = 0;

	// sol alt		
	if(board[row - 3][col - 3] != '\0')
		if(board[row - 1][col - 1] == b[player] && board[row - 2][col - 2] == b[player] && board[row - 3][col - 3] == b[player])
			isRunning = 0;


}
void printTable(){
	printf("X 0 1 2 3 4 5 6 X\n");
	printf("0 %c %c %c %c %c %c %c 0\n", board[0][0],board[0][1],board[0][2],board[0][3],board[0][4],board[0][5],board[0][6]);
	printf("1 %c %c %c %c %c %c %c 0\n", board[1][0],board[1][1],board[1][2],board[1][3],board[1][4],board[1][5],board[1][6]);
	printf("2 %c %c %c %c %c %c %c 0\n", board[2][0],board[2][1],board[2][2],board[2][3],board[2][4],board[2][5],board[2][6]);
	printf("3 %c %c %c %c %c %c %c 0\n", board[3][0],board[3][1],board[3][2],board[3][3],board[3][4],board[3][5],board[3][6]);
	printf("4 %c %c %c %c %c %c %c 0\n", board[4][0],board[4][1],board[4][2],board[4][3],board[4][4],board[4][5],board[4][6]);
	printf("5 %c %c %c %c %c %c %c 0\n", board[5][0],board[5][1],board[5][2],board[5][3],board[5][4],board[5][5],board[5][6]);
	printf("X 0 1 2 3 4 5 6 X\n\n");	
}

void makeMove(int player, int move){
	char a;
	char b[2] = "RY";
	if(move > 6 || move < 0){
		printf("Entered move is not valid\n\n");
		turn--;
		return;
	}	
	for(int i = 0; i < 6; i++){
		a = board[i][move]; 
		if(a == '-' && i == 5){
			board[i][move] = b[player];
			gameFinished(i, move, player);
			return;
		}
		if(a != '-' && i == 0){
			printf("The column is full, try again!\n\n");
			turn--;
		}
		if(a != '-' && i > 0){
			board[i - 1][move] = b[player];
			gameFinished(i - 1, move, player);
			return;
		}	
	}
}






int main(){
	printf("The game has started!\n");
	int move = 0;
	printf("%c", board[7][8]);
	if(board[3][5] == '\0')
		printf("merba");
	while(isRunning != 0){
		if(turn == 1){
			printf("Player 1's Turn (R): \nEnter a move: ");
			scanf("%i", &move);
			printf("\n");
			
			makeMove(0, move);
			
			
			printTable();
			if(isRunning == 0)
				printf("Player 1 has won!\n");
			
		}
		if(turn == 2){
			printf("Player 2's Turn (Y): \nEnter a move: ");
			scanf("%i", &move);
			printf("\n");
			
			makeMove(1, move);
			
			printTable();
			if(isRunning == 0)
				printf("Player 2 has won!\n");
			
		}
		turn = (turn % 2) + 1;
		
	}
	
	
	
	return 0;
}


