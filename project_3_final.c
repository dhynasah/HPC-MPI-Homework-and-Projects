/*
*  GPU- accelerated modeling of point source pollution 
*
*/ 

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
//#define BLOCK_SIZE 256

extern void simulate(double*, double*, int, int); 

int main ( int argc, char *argv[]) 
{
	// declare arrays, and input variables
   	// declare arrays, and input variables
	int SIZEOFARRAY;
	int TimeSteps;
	int InitialConc;

	if(argc != 4){
		printf(" enter : SIZEOFARRAY, TimeSteps, InitialConc"); 
		return 1; 
	}


    	SIZEOFARRAY = atoi(argv[1]); 
	TimeSteps = atoi(argv[2]); 
	InitialConc = atoi(argv[3]); 
	

	if(SIZEOFARRAY < 1 || TimeSteps < 1 || InitialConc < 1) {
		printf("enter only positive numbers greater than 0 for arguments"); 
		return 1; 
	} 

	

	double Density1[SIZEOFARRAY];
	double Density2[SIZEOFARRAY];
	
	// intialize arrays 
	for (int i = 0; i < SIZEOFARRAY; i++) {
		Density1[i]= 0.0;
		Density2[i] = 0.0;
	}
	Density1[0]= InitialConc; 
	Density2[0] = InitialConc; 

	struct timeval start; 
	gettimeofday(&start, NULL);

	simulate(Density1,Density2,SIZEOFARRAY,TimeSteps); 

	struct timeval finish;
	gettimeofday(&finish, NULL);

	FILE *outfile; 
	outfile = fopen("ParallelDensityArray.txt", "w"); 

    if (TimeSteps%2 == 0) {
        for( int i =0; i < SIZEOFARRAY; i++){
            fprintf(outfile, "%f ", Density1[i]); 
       }
   } else {
        for( int i =0; i < SIZEOFARRAY; i++){
            fprintf(outfile, "%f ", Density2[i]); 
        }
    }
	fclose(outfile);
	printf("time %lu\n", finish.tv_usec - start.tv_usec);
	return 0;
} 