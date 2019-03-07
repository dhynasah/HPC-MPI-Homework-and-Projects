/*
 * project_3.cu 
 * includes setup function called from driver program 
 * includes kernel function 'cu_claculateDiffusion()'
 */
 
#include <stdio.h>
#include <stdlib.h>

 
#define BLOCK_SIZE 256

 

__global__ void updateDensity(double *newDensity, double *oldDensity, int SIZEOFARRAY){
	int index; 
	index = blockIdx.x *BLOCK_SIZE + threadIdx.x; 
	if(index == 0){
		newDensity[index] = (oldDensity[index]*2+oldDensity[index+1])/3;
	} else if(index == SIZEOFARRAY) {
		newDensity[index] = (oldDensity[index-1]+oldDensity[index]*2)/3;
	} else {
		newDensity[index] = (oldDensity[index-1]+oldDensity[index]+oldDensity[index+1])/3;
	}	
	
}


extern "C" void simulate(double *Density1, double* Density2, int SIZEOFARRAY, int TimeSteps)
{
	double *Density1_d; 
	double *Density2_d; 
	cudaError_t result;
	 
	//allocate space in the device 
	result = cudaMalloc ((void**) &Density1_d, sizeof(double) * SIZEOFARRAY);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMalloc (Density1) failed.");
		exit(1);
	}
	result = cudaMalloc ((void**) &Density2_d, sizeof(double) * SIZEOFARRAY);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMalloc (Density2) failed.");
		exit(1);
	}

	//copy the arrays from host to the device 
	result = cudaMemcpy (Density1_d, Density1 , sizeof(double) * SIZEOFARRAY, cudaMemcpyHostToDevice);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host->dev (Density1) failed.");
		exit(1);
	}
	result = cudaMemcpy (Density2_d, Density2, sizeof(double) * SIZEOFARRAY, cudaMemcpyHostToDevice);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host->dev (Density2) failed.");
		exit(1);
	}
	
	//set exectuion configuration 
	dim3 dimblock (BLOCK_SIZE);
	dim3 dimgrid (SIZEOFARRAY/BLOCK_SIZE); 
	//function that calls the GPU
	 int i;
	for (i=1; i<= TimeSteps; i++){
		if (i%2 == 0) {
            updateDensity<<<dimgrid,dimblock>>>(Density1_d, Density2_d, SIZEOFARRAY); 
		 
        } 
	else {
              updateDensity<<<dimgrid,dimblock>>>(Density2_d, Density1_d, SIZEOFARRAY);		
        }
		
	}
	
	
	result = cudaMemcpy (Density1, Density1_d, sizeof(double) * SIZEOFARRAY, cudaMemcpyDeviceToHost);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host <- dev (Density1) failed.");
		exit(1);
	}
	result = cudaMemcpy (Density2, Density2_d, sizeof(double) * SIZEOFARRAY, cudaMemcpyDeviceToHost);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host <- dev (Density2) failed.");
		exit(1);
	}
	
	// release the memory on the GPU 
	result = cudaFree (Density1_d);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaFree (Density1) failed.");
		exit(1);
	}
	result = cudaFree (Density2_d);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaFree (Density2) failed.");
		exit(1);
	}
	}