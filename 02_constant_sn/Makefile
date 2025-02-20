CC=gcc
DEBUG= -g -Wall
PTHREADSLIB= -lpthread

pth_hello : pth_hello.c
	$(CC) $(DEBUG) -o pth_hello pth_hello.c $(PTHREADSLIB)

clean:
	rm -f pth_hello

.PHONY: clean
