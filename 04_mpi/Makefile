CC = mpicc
CFLAGS = -g -Wall

all: mpi_hello

mpi_hello: mpi_hello.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f mpi_hello

.PHONY: clean
