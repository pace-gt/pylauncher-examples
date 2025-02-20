#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int thread_count;

void *hello(void *rank);

int main(int argc, char *argv[]) {
  long thread;
  pthread_t *thread_handles;

  thread_count = strtol(argv[1], NULL, 10);

  thread_handles = malloc(thread_count * sizeof(pthread_t));

  for (thread = 0; thread < thread_count; thread++)
    pthread_create(&thread_handles[thread], NULL, hello, (void *)thread);

  printf("hello from the main thread\n");

  for (thread = 0; thread < thread_count; thread++)
    pthread_join(thread_handles[thread], NULL);

  free(thread_handles);
  return 0;
}

void *hello(void *rank) {
  long my_rank = (long)rank;

  printf("hello from thread %ld of %d\n", my_rank, thread_count);
  long j;
  for (j = 0; j < 1000000000; ++j) {
    continue;
  }
  printf("%ld\n", j);

  return NULL;
}
