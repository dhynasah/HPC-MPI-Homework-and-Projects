#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>


void updateDensity(double *newDensity, double *oldDensity, int SIZEOFARRAY,int Conc ){
    newDensity[0] = (oldDensity[0]*2+oldDensity[1])/3;
    for(int i = 1; i < (SIZEOFARRAY-1); i++ ) {
        newDensity[i] = (oldDensity[i-1]+oldDensity[i]+oldDensity[i+1])/3;
    }
    newDensity[SIZEOFARRAY]=(oldDensity[SIZEOFARRAY-1]+oldDensity[SIZEOFARRAY]*2)/3;
}

int main (int argc, char *argv[])
{
	struct timeval start; 
	gettimeofday(&start, NULL);
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

	for (int i = 1; i< SIZEOFARRAY; i++) {
		Density1[i]= 0.0;
		Density2[i] = 0.0;
	}
    Density1[0]=InitialConc;
    Density2[0]=InitialConc;

    for (int i=1; i<= TimeSteps; i++){
            if (i%2 == 0) {
                updateDensity(Density1,Density2,SIZEOFARRAY, InitialConc );
            } else {
                updateDensity(Density2,Density1,SIZEOFARRAY,InitialConc);
            }
    }
	struct timeval finish;
	gettimeofday(&finish, NULL);

	FILE *outfile; 
	outfile = fopen("DensityArray.txt", "w"); 

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
