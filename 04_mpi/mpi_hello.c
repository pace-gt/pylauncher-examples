#include "mpi.h"
#include "unistd.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int job_id, sleep_sec, my_rank, n_ranks;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &n_ranks);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  if (my_rank == 0 && argc < 2) {
    printf("Usage: mpi_hello job_id sleep_seconds\n");
    MPI_Abort(MPI_COMM_WORLD, 1);
  }

  job_id = atoi(argv[1]);
  sleep_sec = atoi(argv[2]);

  char outfile[16];
  sprintf(outfile, "pytmp-%04d-%04d", job_id, my_rank);

  FILE *f = fopen(outfile, "w");
  fprintf(f, "%d/%d working\n", my_rank, n_ranks);
  fclose(f);

  if (my_rank == 0) {
    printf("Job %d on %d processors\n", job_id, n_ranks);
  }
  sleep(sleep_sec);
  MPI_Finalize();
}
