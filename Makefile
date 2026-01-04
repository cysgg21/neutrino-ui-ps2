EE_BIN  = nhui.elf
EE_OBJS = src/main.o assets_build/bg.o assets_build/disc.o

# Incluir headers de ports (donde se instalan gsKit/dmaKit)
EE_INCS += -I$(PS2SDK)/ports/ee/include -I$(PS2SDK)/ports/common/include

# Linkear libs de ports
EE_LDFLAGS += -L$(PS2SDK)/ports/ee/lib -L$(PS2SDK)/ports/common/lib

# OJO: si NO usas gsKit_toolkit en tu código, quítalo (recomendado)
EE_LIBS += -lgsKit -ldmaKit -lpad -lc
# EE_LIBS += -lgsKit -ldmaKit -lgskit_toolkit -lpad -lc

all: $(EE_BIN)

# Generar raws automáticamente si no existen
assets_build/bg.raw assets_build/disc.raw: tools/build_assets.py assets_src/bg.png assets_src/disc_icon.png
	python3 tools/build_assets.py

assets_build/bg.o: assets_build/bg.raw
	ee-ld -r -b binary -o $@ $<

assets_build/disc.o: assets_build/disc.raw
	ee-ld -r -b binary -o $@ $<

clean:
	rm -f $(EE_OBJS) $(EE_BIN) assets_build/bg.raw assets_build/disc.raw

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
