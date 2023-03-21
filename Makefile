# assembler
ASM = /usr/bin/nasm
# compiler
CC = /usr/bin/gcc
CONFIG = ./config
# linker
LD = /usr/bin/ld
# grub iso creator
GRUB = /usr/bin/grub-mkrescue
# sources
SRC = src
ASM_SRC = $(SRC)/asm
# objects
OBJ = obj
ASM_OBJ = $(OBJ)/asm
OUT = out
INC = ./include
INCLUDE=-I$(INC)

MKDIR= mkdir -p
CP = cp -f
DEFINES=

# assembler flags
ASM_FLAGS = -f elf32
# compiler flags
CC_FLAGS = $(INCLUDE) $(DEFINES) -m32 -std=gnu99 -fno-pie -ffreestanding -Wall -Wextra -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin  
# linker flags, for linker add linker.ld file too
LD_FLAGS = -m elf_i386 -T $(CONFIG)/linker.ld -nostdlib

# target file to create in linking
TARGET=$(OUT)/Kernel.bin

# iso file target to create
TARGET_ISO=$(OUT)/Kernel.iso
ISO_DIR=$(OUT)/isodir

OBJECTS=$(ASM_OBJ)/boot.o\
		$(OBJ)/kernel.o \
		$(OBJ)/gdt.o \
 		$(OBJ)/idt.o \
 		$(OBJ)/isr.o \
 		$(OBJ)/irq.o \
 		$(OBJ)/timer.o \
 		$(OBJ)/keyboard.o \
		$(OBJ)/scrn.o \
		$(OBJ)/mouse.o \
		$(OBJ)/utils.o 



run: $(TARGET_ISO)
	qemu-system-x86_64 $(TARGET_ISO)

$(TARGET_ISO): $(OBJECTS)
	@printf "[ linking... ]\n"
	$(LD) $(LD_FLAGS) -o $(TARGET) $(OBJECTS)
	grub-file --is-x86-multiboot $(TARGET)
	@printf "\n"
	@printf "[ building ISO... ]\n"
	$(MKDIR) $(ISO_DIR)/boot/grub
	$(CP) $(TARGET) $(ISO_DIR)/boot/
	$(CP) $(CONFIG)/grub.cfg $(ISO_DIR)/boot/grub/
	$(GRUB) -o $(TARGET_ISO) $(ISO_DIR)
	rm -f $(TARGET)

$(ASM_OBJ)/boot.o : $(ASM_SRC)/boot.s
	@printf "[ $(ASM_SRC)/boot.s ]\n"
	$(ASM) $(ASM_FLAGS) $(ASM_SRC)/boot.s -o $(ASM_OBJ)/boot.o
	@printf "\n"

$(OBJ)/char.o : $(SRC)/char.c
	@printf "[ $(SRC)/char.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/char.c -o $(OBJ)/char.o
	@printf "\n"

$(OBJ)/kernel.o : $(SRC)/kernel.c
	@printf "[ $(SRC)/kernel.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/kernel.c -o $(OBJ)/kernel.o
	@printf "\n"

$(OBJ)/utils.o : $(SRC)/utils.c
	@printf "[ $(SRC)/utils.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/utils.c -o $(OBJ)/utils.o
	@printf "\n"

$(OBJ)/scrn.o : $(SRC)/scrn.c
	@printf "[ $(SRC)/scrn.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/scrn.c -o $(OBJ)/scrn.o
	@printf "\n"

$(OBJ)/gdt.o : $(SRC)/gdt.c
	@printf "[ $(SRC)/gdt.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/gdt.c -o $(OBJ)/gdt.o
	@printf "\n"

$(OBJ)/idt.o : $(SRC)/idt.c
	@printf "[ $(SRC)/idt.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/idt.c -o $(OBJ)/idt.o
	@printf "\n"

$(OBJ)/isr.o : $(SRC)/isr.c
	@printf "[ $(SRC)/isr.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/isr.c -o $(OBJ)/isr.o
	@printf "\n"

$(OBJ)/irq.o : $(SRC)/irq.c
	@printf "[ $(SRC)/irq.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/irq.c -o $(OBJ)/irq.o
	@printf "\n"

$(OBJ)/timer.o : $(SRC)/timer.c
	@printf "[ $(SRC)/timer.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/timer.c -o $(OBJ)/timer.o
	@printf "\n"

$(OBJ)/keyboard.o : $(SRC)/keyboard.c
	@printf "[ $(SRC)/keyboard.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/keyboard.c -o $(OBJ)/keyboard.o
	@printf "\n"

$(OBJ)/utils.o : $(SRC)/utils.c
	@printf "[ $(SRC)/util.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/utils.c -o $(OBJ)/utils.o
	@printf "\n"

$(OBJ)/mouse.o : $(SRC)/mouse.c
	@printf "[ $(SRC)/mouse.c ]\n"
	$(CC) $(CC_FLAGS) -c $(SRC)/mouse.c -o $(OBJ)/mouse.o
	@printf "\n"

clean:
	rm -f $(OBJ)/*.o
	rm -f $(ASM_OBJ)/*.o
	rm -rf $(OUT)/*
