#include "vga.h"
#include "kernel.h"
#include "utils.h"

static uint8_t *vga_buffer = (uint8_t *)0xA0000;

void vga_init()
{
    // Set video mode 320x200 256 color graphics (VGA) by calling BIOS int 10h
    regs16_t regs;
    regs.ax = 0x0013;
    int32(0x10, &regs);
}

#define PALETTE_WRITE 0x3C8
#define PALETTE_DATA 0x3C9

void vga_set_palette_color(uint8_t palette_no, uint8_t r, uint8_t g, uint8_t b)
{
    outportb(PALETTE_WRITE, palette_no);
    // Valid range of r, g, b is 0 - 63
    outportb(PALETTE_DATA, r);
    outportb(PALETTE_DATA, g);
    outportb(PALETTE_DATA, b);
}

void vga_buffer_draw_pixel(uint8_t *buffer, int x, int y, uint8_t palette_no)
{
    buffer[y * VGA_WIDTH + x] = palette_no;
}

void vga_buffer_clear(uint8_t *buffer)
{
    memset(buffer, 0, VGA_WIDTH * VGA_HEIGHT);
}

void vga_draw_buffer(const uint8_t *buffer)
{
    memcpy(vga_buffer, buffer, VGA_WIDTH * VGA_HEIGHT);
}

static uint8_t buffer[VGA_WIDTH * VGA_HEIGHT];

void screen_init()
{
    // VGA graphics mode
    vga_init();
    // Set palette color
    for (int i = 0; i < 64; i++)
    {
        vga_set_palette_color(i, i, i, i);
    } // Shades of gray
    for (int i = 0; i < 64; i++)
    {
        vga_set_palette_color(64 + i, i, 0, 0);
    } // Shades of red
    for (int i = 0; i < 64; i++)
    {
        vga_set_palette_color(128 + i, 0, i, 0);
    } // Shades of green
    for (int i = 0; i < 64; i++)
    {
        vga_set_palette_color(192 + i, 0, 0, i);
    } // Shades of blue
}

int draw_vga()
{
    screen_init();
    for (int i = 0; i < 100; i++)
    {
        vga_buffer_draw_pixel(buffer, i, i, 10);
    }
    vga_draw_buffer(buffer);
    return 0;
}
