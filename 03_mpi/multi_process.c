#include "mpi.h"
#include "unistd.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int my_rank, n_ranks;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &n_ranks);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  long sum;
  for (sum = 0; sum < 1000000000; ++sum) {
    continue;
  }

  for (int i = 0; i < n_ranks; ++i) {
    if (my_rank == i) {
      printf("Rank %d out of %d computed %ld\n", my_rank, n_ranks, sum);
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }

  MPI_Finalize();
}
