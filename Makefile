EE_BIN  = nhui.elf
EE_OBJS = src/main.o assets_build/bg.o assets_build/disc.o

EE_LIBS += -lgsKit -ldmaKit -lgskit_toolkit -lpad -lc

all: $(EE_BIN)

assets_build/bg.o: assets_build/bg.raw
	ee-ld -r -b binary -o $@ $<

assets_build/disc.o: assets_build/disc.raw
	ee-ld -r -b binary -o $@ $<

clean:
	rm -f $(EE_OBJS) $(EE_BIN)

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
