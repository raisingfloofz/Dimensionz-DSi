ifeq ($(strip $(DEVKITARM)),)
$(error DEVKITARM is not set)
endif
include $(DEVKITARM)/ds_rules
TARGET := Dimensionz
BUILD := build
SOURCES := source
ARCH := -mthumb -mthumb-interwork
CFLAGS := -g -Wall -O2 $(ARCH) -I$(LIBNDS)/include
LDFLAGS := -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,Dimensionz.map
LIBS := -lfat -lnds9
.PHONY: all clean
all: $(TARGET).nds
$(TARGET).elf: source/main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< -L$(LIBNDS)/lib $(LIBS) -o $@
clean:
	rm -f $(TARGET).elf $(TARGET).nds Dimensionz.map
