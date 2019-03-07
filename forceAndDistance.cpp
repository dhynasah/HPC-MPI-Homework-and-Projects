/*
 * ForceAndDistance.c
 * A "driver" program that calls a routine (i.e. a kernel)
 * that executes on the GPU.  The kernel fills 3 int arrays
 * with random numbers from 1-100, and 1-10. 
 * the kernel then fills the work array with the product of 
 * the corresponding force and dist index 
 *
 * Note: the kernel code is found in the file 'ForceAndDistance.cu'
 * 
 */

#include <stdio.h>
#define SIZEOFARRAY 200,000,000

extern void fillArray(int *forceId , int *distId, int *workId int size); 

int main (int argc, char *argv[])
{

	//declare arrays and intialize to 0 
	int forceId[SIZEOFARRAY];
	int distId[SIZEOFARRAY];
	int workId[SIZEOFARRAY]; 
	int i; 
	for (i =0; i < SIZEOFARRAY; i++){
		forceId[i]=0;
		distId[i]=0; 
		workId[i]=0; 
	}
	
	// Print the intial array
	printf("inital state of array forceId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", forceId[i];
	}
	printf("\n"); 
	
	printf("inital state of array distId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", distId[i];
	}
	printf("\n"); 
	
	printf("inital state of array workId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", workId[i];
	}
	printf("\n"); 
	
	// function that will call the GPU function
	fillArray(forceID, distId, workId, SIZEOFARRAY); 
	
	// print arrays afer they are filled 
	
	printf("inital state of array forceId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", forceId[i];
	}
	printf("\n"); 
	printf("inital state of array distId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", distId[i];
	}
	printf("\n"); 
	printf("inital state of array workId:\n");
	for(i =0; i <SIZEOFARRAY; i++){
		printf("%d ", workId[i];
	}
	printf("\n"); 
	
	
	return 0; 
	}