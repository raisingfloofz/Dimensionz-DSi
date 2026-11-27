ifeq ($(strip $(DEVKITARM)),)
$(error DEVKITARM is not set)
endif

include $(DEVKITARM)/ds_rules

.DEFAULT_GOAL := all

TARGET := Dimensionz

GAME_TITLE := Dimensionz
GAME_SUBTITLE1 := Personal Chat Diary
GAME_SUBTITLE2 := DSi Edition

ARCH := -march=armv5te -mtune=arm946e-s

CFLAGS := -g -Wall -O2 $(ARCH)
CFLAGS += -DARM9 -D__NDS__
CFLAGS += -ffunction-sections -fdata-sections

LIBDIRS := $(LIBNDS) $(CALICO) $(PORTLIBS)

CFLAGS += $(foreach dir,$(LIBDIRS),-I$(dir)/include)

LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

LDFLAGS = -specs=ds_arm9.specs -g $(ARCH)
LDFLAGS += -Wl,-Map,Dimensionz.map

FATLIB := $(firstword $(foreach dir,$(LIBDIRS),$(wildcard $(dir)/lib/libfat.a)))
DVMLIB := $(firstword $(foreach dir,$(LIBDIRS),$(wildcard $(dir)/lib/libdvm.a)))

LIBS := $(if $(DVMLIB),$(DVMLIB),$(if $(FATLIB),$(FATLIB),-lfat)) -lnds9

LD := $(CC)
OFILES := main.o

.PHONY: all clean

all: $(TARGET).nds

main.o: source/main.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).elf: $(OFILES)

$(TARGET).nds: $(TARGET).elf

clean:
	rm -f main.o Dimensionz.elf Dimensionz.nds Dimensionz.map Dimensionz.lst
