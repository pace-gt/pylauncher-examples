CC = mpicc
CFLAGS = -g -Wall

all: multi_process

multi_process: multi_process.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f multi_process

.PHONY: clean
