ifeq ($(strip $(DEVKITARM)),)
$(error DEVKITARM is not set)
endif

include $(DEVKITARM)/ds_rules

.DEFAULT_GOAL := all

TARGET := Dimensionz

GAME_TITLE := Dimensionz
GAME_SUBTITLE1 := Personal Chat Diary
GAME_SUBTITLE2 := DSi Edition

ARCH := -march=armv5te -mtune=arm946e-s -mthumb

CFLAGS := -g -Wall -O2 $(ARCH)
CFLAGS += -DARM9 -D__NDS__
CFLAGS += -I/opt/devkitpro/libnds/include
CFLAGS += -I/opt/devkitpro/calico/include
CFLAGS += -ffunction-sections -fdata-sections

LDFLAGS := -specs=/opt/devkitpro/calico/share/ds9.specs
LDFLAGS += -g $(ARCH)
LDFLAGS += -Wl,-Map,Dimensionz.map
LDFLAGS += -L/opt/devkitpro/libnds/lib
LDFLAGS += -L/opt/devkitpro/calico/lib

LIBS := -Wl,--start-group
LIBS += /opt/devkitpro/libnds/lib/libfat.a
LIBS += /opt/devkitpro/libnds/lib/libnds9.a
LIBS += /opt/devkitpro/calico/lib/libcalico_ds9.a
LIBS += -Wl,--end-group

.PHONY: all clean

all: $(TARGET).nds

main.o: source/main.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).elf: main.o
	$(CC) $(LDFLAGS) main.o $(LIBS) -o $@

$(TARGET).nds: $(TARGET).elf

clean:
	rm -f main.o Dimensionz.elf Dimensionz.nds Dimensionz.map Dimensionz.lst
