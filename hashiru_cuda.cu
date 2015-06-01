#include <cstdio>
#include <string.h>
#include <cuda_runtime.h>
#include "hashiru_cuda.cuh"

__global__ void cudaCrackHashKernel(const char *dict, const int max_length, const int dict_size, const char *to_crack, int *correct_idx)
{
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    char *current, *cur_hash, *c1, *c2;
    int equal;
    while(idx < dict_size)
    {
        current = (char *) (dict + idx * max_length);
        //TODO: cur_hash = salsa20_gpu(current);
        //TODO: if(strcmp(cur_hash, to_crack) == 0)
        c1 = cur_hash;
        c2 = (char *)to_crack;
        equal = 0;
        while(*c1 != '\0' && *c2 != '\0')
        {
            if(*c1 != *c2)
            {
                equal = 1;
                break;
            }
            c1++;
            c2++;
        }
        equal = ((*c1 != '\0') || (*c2 != '\0'));
        if(equal == 0)
        {
            *correct_idx = idx;
            break;
        }
        idx += blockDim.x * gridDim.x;
    }
}

void cudaCallCrackHashKernel(const unsigned int blocks,
         const unsigned int threadsPerBlock,
         const char *dict,
         const int max_length,
         const int dict_size,
         const char *to_crack,
         int *correct_idx)
{
    // TODO:  cudaCrackHashKernel<<<blocks, threadsPerBlock>>>(dict, max_length, dict_size, to_crack, correct_idx);
}
