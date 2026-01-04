EE_BIN  = nhui.elf
EE_OBJS = src/main.o assets_build/bg.o assets_build/disc.o

# Incluir headers de PORTS (gsKit/dmaKit)
EE_INCS += -I$(PS2SDK)/ports/include
# Linkear libs de PORTS
EE_LDFLAGS += -L$(PS2SDK)/ports/lib

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
