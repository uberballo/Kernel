#ifndef VGA_H
#define VGA_H

#include <stdint.h>

extern void int32();

#define PACKED __attribute__((packed))

// Registers
typedef struct PACKED
{
    uint16_t di, si, bp, sp, bx, dx, cx, ax;
    uint16_t gs, fs, es, ds, eflags;
} regs16_t;

#define VGA_WIDTH 320
#define VGA_HEIGHT 200

extern void vga_init();
extern int draw_vga();

#endif