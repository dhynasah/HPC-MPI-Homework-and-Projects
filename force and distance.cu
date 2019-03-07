/*
 * Dhynasah Cakir 
 * force and distance 
 * homework 7 
 * 10/17/18
 */

#include <stdio.h>
#include <stdlib.h>

// global directive for kernel 
_global_ void cu_fillArray( int *force_d, int *dist_d, int *work_d) 
{
	int x;  
	// using built in variables 
	x = blockIdx.x * BLOCK_SIZE + threadId.x; 
	force_d[x] = rand()%100+1; 
	dist_d[x] = rand()%10+1; 
	work_d[x] = force[x] * dist_d[x]; 

}

extern "C" void fillArray (int *force, int *dist, int *work, int arraySize)
{
	// force_d, dist_d, and work_d are the GPU counterparts of the arrays that exists in host memory 
	int *force_d;
	int *dist_d;
	int *work_d;
	cudaError_t result;

	// allocate space in the device 
	result = cudaMalloc ((void**) &force_d, sizeof(int) * arraySize);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMalloc (force) failed.");
		exit(1);
	}
	result = cudaMalloc ((void**) &dist_d, sizeof(int) * arraySize);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMalloc (dist) failed.");
		exit(1);
	}
	result = cudaMalloc((void**) &work_d, sizeof(int) * arraySize);
	if( result != cudaSuccess) {
		fprintf(stderr, "cudaMalloc (work) failed.");
	}

	//copy the arrays from host to the device 
	result = cudaMemcpy (force_d, force, sizeof(int) * arraySize, cudaMemcpyHostToDevice);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host->dev (force) failed.");
		exit(1);
	}
	result = cudaMemcpy (dist_d, dist, sizeof(int) * arraySize, cudaMemcpyHostToDevice);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host->dev (dist) failed.");
		exit(1);
	}
	
	result = cudaMemcpy (work_d, work, sizeof(int) * arraySize, cudaMemcpyHostToDevice);
	if( result != cudaSuccess){
		fprintf(stderr, "cudaMalloc (work) failed.");
		exit(1); 
	}

	// set execution configuration
	dim3 dimblock (BLOCK_SIZE);
	dim3 dimgrid (arraySize/BLOCK_SIZE);

	// actual computation: Call the kernel
	cu_fillArray <<<dimgrid, dimblock>>> (force_d, dist_d, work_d);

	// transfer results back to host
	result = cudaMemcpy (work, work_d, sizeof(int) * arraySize, cudaMemcpyDeviceToHost);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host <- dev (work) failed.");
		exit(1);
	}
	result = cudaMemcpy (dist, dist_d, sizeof(int) * arraySize, cudaMemcpyDeviceToHost);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host <- dev (dist) failed.");
		exit(1);
	}
	result = cudaMemcpy (force, force_d, sizeof(int) * arraySize, cudaMemcpyDeviceToHost);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy host <- dev (force) failed.");
		exit(1);
	}
	
	// release the memory on the GPU 
	result = cudaFree (force_d);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaFree (block) failed.");
		exit(1);
	}
	result = cudaFree (dist_d);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaFree (thread) failed.");
		exit(1);
	}
	result = cudaFree (work_d);
	if (result != cudaSuccess) {
		fprintf(stderr, "cudaFree (thread) failed.");
		exit(1);
	}
}

