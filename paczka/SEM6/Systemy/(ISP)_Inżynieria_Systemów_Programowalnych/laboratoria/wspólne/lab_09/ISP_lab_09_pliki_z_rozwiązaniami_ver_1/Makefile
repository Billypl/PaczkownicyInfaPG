# Simple Makefile
TARGET = gray
SYSTEMC = /usr/local/systemc
INCDIR = -I. -I/usr/local/systemc/include
LIBDIR = -L. -L/usr/local/systemc/lib-cygwin64
LIBS   = -lsystemc -lm

CC     = g++
CFLAGS = -g -Wno-deprecated -Wall -std=c++17 -O0 -fpermissive

OBJS   = testbench.o

EXE    = $(TARGET)

all: $(EXE)

$(EXE): $(OBJS)
	$(CC) $(CFLAGS) $(INCDIR) $(LIBDIR) -o $@ $(OBJS) $(LIBS) 2>&1

testbench.o:	testbench.cpp design.h
	$(CC) $(CFLAGS) $(INCDIR) -c $<

clean:
	rm -f $(OBJS) $(EXE) *.vcd
