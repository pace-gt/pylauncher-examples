CC = gcc
DEBUG = -g -Wall
PTHREADSLIB = -lpthread

multi_thread : multi_thread.c
	$(CC) $(DEBUG) -o multi_thread multi_thread.c $(PTHREADSLIB)

clean:
	rm -f multi_thread

.PHONY: clean
