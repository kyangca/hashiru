#include <cstdio>
#include <string.h>
#include <cuda_runtime.h>
#include "hashiru_cuda.cuh"

// TODO: Write kernels
__global__ void cudaCrackHashKernel(char *dict, const int max_length, const int dict_size, const char *to_crack, int *correct_idx)
{
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    char *current, *cur_hash;
    while(idx < dict_size)
    {
        current = dict + idx * max_length;
        //TODO: cur_hash = salsa20_gpu(current);
        //TODO: if(strcmp(cur_hash, to_crack) == 0)
        if(0)
        {
            *correct_idx = idx;
            break;
        }
        idx += blockDim.x * gridDim.x;
    }
}

void cudaCallCrackHashKernel(const unsigned int blocks,
         const unsigned int threadsPerBlock,
         char *dict,
         const int max_length,
         const int dict_size,
         const char *to_crack,
         int *correct_idx)
{
    // TODO:  cudaCrackHashKernel<<<blocks, threadsPerBlock>>>(dict, max_length, dict_size, to_crack, correct_idx);
}
