ifeq ($(strip $(DEVKITARM)),)
$(error DEVKITARM is not set)
endif

include $(DEVKITARM)/ds_rules

TARGET := Dimensionz
BUILD := build
SOURCES := source

CALICO := $(DEVKITPRO)/calico

ARCH := -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork

CFLAGS := -g -Wall -O2 $(ARCH) -DARM9
CFLAGS += -I$(LIBNDS)/include
CFLAGS += -I$(CALICO)/include

LDFLAGS := -specs=ds_arm9.specs -g $(ARCH)
LDFLAGS += -Wl,-Map,Dimensionz.map

LIBS := -lnds9 -lcalico_ds9

LIBDIRS := -L$(LIBNDS)/lib -L$(CALICO)/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).elf: source/main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< $(LIBDIRS) $(LIBS) -o $@

clean:
	rm -f $(TARGET).elf $(TARGET).nds Dimensionz.map
