#ifndef CUDA_HASHIRU_CUH
#define CUDA_HASHIRU_CUH

void cudaCallCrackHashKernel(const unsigned int blocks,
         const unsigned int threadsPerBlock,
         const char *dict,
         const int max_length,
         const int dict_size,
         const char *to_crack,
         int *correct_idx);

#endif // CUDA_HASHIRU_CUH
