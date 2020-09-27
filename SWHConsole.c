#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <Windows.h>
#include <conio.h>
#include <math.h>
#include <string.h>
#include <limits.h>
#include <io.h>

#define MAX_LEN 8192
#define BUFFER_SIZE 1024
#define strcasecmp _stricmp


const char program_name[MAX_LEN] = "Scripting Windows Host Console";
const char program_name_script[MAX_LEN] = "Scripting Windows Host";
const char script_extension[MAX_LEN] = ".swh";
const char shortprogram_name_cap[MAX_LEN] = "SWH";
const char shortprogram_name_lwr[MAX_LEN] = "swh";
const char shortprogram_name_cap_con[MAX_LEN] = "SWH Console";
const char shortprogram_name_lwr_con[MAX_LEN] = "swh console";


const char failed_curdir[BUFFER_SIZE] = "Failed to get current directory";
// const char failed_curdir[BUFFER_SIZE] = "Failed to get current directory";

void BackSpace()
{
    putchar('\b');
    putchar(' ');
    putchar('\b');

}

void ClearScreen()
{
  HANDLE                     hStdOut;
  CONSOLE_SCREEN_BUFFER_INFO csbi;
  DWORD                      count;
  DWORD                      cellCount;
  COORD                      homeCoords = { 0, 0 };

  hStdOut = GetStdHandle( STD_OUTPUT_HANDLE );
  if (hStdOut == INVALID_HANDLE_VALUE) return;

  /* Get the number of cells in the current buffer */
  if (!GetConsoleScreenBufferInfo( hStdOut, &csbi )) return;
  cellCount = csbi.dwSize.X *csbi.dwSize.Y;

  /* Fill the entire buffer with spaces */
  if (!FillConsoleOutputCharacter(
    hStdOut,
    (TCHAR) ' ',
    cellCount,
    homeCoords,
    &count
    )) return;


  if (!FillConsoleOutputAttribute(
    hStdOut,
    csbi.wAttributes,
    cellCount,
    homeCoords,
    &count
    )) return;

  /* Move the cursor home */
  SetConsoleCursorPosition( hStdOut, homeCoords );
}


 int main(int argc, char* argv[])
 {
     if(argv[1] != NULL)
     {
        printf("\nSyntax:\n\n%s [/c commmand]\n\nExample:\n\n%s /c echo\n\nCopyright (c) 2020 anic17 software");
        exit(0);


     }


	TCHAR infoBuf[BUFFER_SIZE];
	SetConsoleTitle(program_name);

	char echo[MAX_LEN];
	char command[MAX_LEN];
	// char cd[PATH_MAX];
	char* cd;
	while(1){
        fprintf(stdout, "Welcome to the %s [Clang Alpha 0.0.1]\n\n", program_name);

        char * curdir = getenv("USERPROFILE");

        if((cd = getcwd(NULL, 0)) == NULL)
            {
                printf("%s\n", failed_curdir);
                exit(EXIT_FAILURE);
            }
        while(1)
            {
            printf("%s %s: ", cd, shortprogram_name_cap);

            fgets(command, MAX_LEN, stdin);
            // BackSpace();
            if(!strcmp(command, "\n"))
               {
                printf("\n");
            } else if(command[0] == (int)4)
                {
                    printf("KeyboardInterrupt\n\n");
                } else {

                command[strlen(command)-1] = '\0';

                if(!strcasecmp(command, "echo"))
                {
                    printf("Text to echo: ");
                    fgets(echo, sizeof echo, stdin);
                    echo[strlen(echo)-1] = '\0';
                    printf("%s\n",echo);
                } else if(!strcasecmp(command, "cls"))
                {
                    ClearScreen();
                } else if(!strcasecmp(command, shortprogram_name_lwr))
                {
                    ClearScreen();
                    break;
                } else if(!strcasecmp(command, "exit"))
                {
                    exit(0);
                } else {
                    printf("This command does not exist. Type \"help\" to see the commands available\n\n");
                }
            }
        }

    }
 }
