#ifndef KERNEL_H
#define KERNEL_H

/* MAIN.C */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern char *memset(char *dest, char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern int strlen(const char *str);
extern unsigned char inportb (unsigned short _port);
extern void outportb (unsigned short _port, unsigned char _data);

#include "scrn.h"
#include "gdt.h"
#include "idt.h"
#include "irs.h"
#include "irq.h"
#include "timer.h"
#include "keyboard.h"

#endif