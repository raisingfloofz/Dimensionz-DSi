ifeq ($(strip $(DEVKITARM)),)
$(error DEVKITARM is not set)
endif

include $(DEVKITARM)/ds_rules

TARGET := Dimensionz

GAME_TITLE := Dimensionz
GAME_SUBTITLE1 := Personal Chat Diary
GAME_SUBTITLE2 := DSi Edition

CALICO := $(DEVKITPRO)/calico

ARCH := -march=armv5te -mtune=arm946e-s -mthumb

CFLAGS := -g -Wall -O2 $(ARCH)
CFLAGS += -DARM9 -D__NDS__
CFLAGS += -I$(LIBNDS)/include
CFLAGS += -I$(CALICO)/include

LDFLAGS := -specs=$(CALICO)/share/ds9.specs
LDFLAGS += -g $(ARCH)
LDFLAGS += -Wl,-Map,Dimensionz.map

LIBDIRS := -L$(LIBNDS)/lib
LIBDIRS += -L$(CALICO)/lib

LIBS := -ldvm -lnds9 -lcalico_ds9

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).elf: source/main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< $(LIBDIRS) $(LIBS) -o $@

clean:
	rm -f $(TARGET).elf $(TARGET).nds Dimensionz.map
