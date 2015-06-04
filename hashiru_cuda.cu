#include <cstdio>
#include <string.h>
#include <cuda_runtime.h>
#include "hashiru_cuda.cuh"

// A GPU version of the toy hash function from earlier.
// Could be done in a more parallel manner, but at this
// time I just want it to work.
__device__ void cuda_hash(const char *in, const int len, char *out)
{
   char c = 0;
   for(int i = 0; i < len; i++)
   {
       c += (char)in[i];
   }
   c = 97 + c % 26;
   out[0] = c;
   for(int i = 1; i < 32; i++)
   {
       out[i] = 'F';
   }
   out[32] = '\0';
}

__global__ void cudaCrackHashKernel(const char *dict, const int max_length, const int dict_size, const char *to_crack, int *correct_idx)
{
    // Calculate this thread's index.
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    // Set aside some memory for the GPU hash function to write
    // to.  Suboptimal, but it works.
    char *current, *cur_hash = (char *)malloc(33 * sizeof(char));
    int equal, len;
    char *c;
    // Iterate over the whole dictionary.
    while(idx < dict_size)
    {
        // Get the current word for consideration.
        current = (char *) (dict + idx * (max_length + 1));
        // Calculate its length in a loop.  Again, janky and not
        // parallel, but it works.
        len = 0;
        c = current;
        while(*c != '\0')
        {
            len++;
            c++;
        }
        // Nuke the hash buffer, and call the GPU hash function.
        memset(cur_hash, 0, 33);
        cuda_hash(current, len, cur_hash);
        // Super sketchy strcmp implementation.  Not parallel
        // and not efficient, but hopefully it should work.
        equal = 1;
        for(int i = 0; i < 32; i++)
        { 
            if(to_crack[i] != cur_hash[i]) equal = 0;
        }
        // Only if you stumble across the answer do you update
        // correct_idx.  If a collision occurs, it only matters
        // that one of the correct answers gets written, not
        // which one.
        if(equal)
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
    // Call the kernel with the appropriate parameters.
    cudaCrackHashKernel<<<blocks, threadsPerBlock>>>(dict, max_length, dict_size, to_crack, correct_idx);
}
