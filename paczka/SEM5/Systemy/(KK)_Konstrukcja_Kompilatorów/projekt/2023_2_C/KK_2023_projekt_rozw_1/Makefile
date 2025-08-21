#
CC=gcc
LEX=flex

% : %.tab.o %.o 
	$(CC) $< $*.o $(LDFLAGS) -o $@

%.tab.c %.tab.h: %.y
	bison -d -v $<

%.c: %.l %.tab.h
	$(LEX) -t $< > $@

c: c.y c.l

