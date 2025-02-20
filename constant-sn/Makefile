CC=gcc
MPICC=mpicc
DEBUG= -g -Wall
PTHREADSLIB= -lpthread

all: pth_hello mpi_hello

pth_hello : pth_hello.c
	$(CC) $(DEBUG) -o pth_hello pth_hello.c $(PTHREADSLIB)

mpi_hello : mpi_hello.c
	$(MPICC) $(DEBUG) -o mpi_hello mpi_hello.c

clean:
	rm -f pth_hello mpi_hello

.PHONY: clean
