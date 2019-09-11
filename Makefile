objs := header.o main.o
out := sandbox.nes

all: $(out)

clean:
	rm -f $(objs) $(out)

.PHONY: all clean

# Assemble

%.o: %.s
	ca65 $< -o $@

main.o: main.s defs.s
header.o: header.s

# Link

sandbox.nes: nes.cfg $(objs)
	ld65 -C nes.cfg $(objs) -o $@
