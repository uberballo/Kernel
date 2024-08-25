#include "kernel.h"

void main()
{
  gdt_install();
  idt_install();
  isrs_install();
  irq_install();
  asm volatile("sti"); // Set interrupt flag
  init_video();
  timer_install();
  keyboard_install();
  // update_time(0);
  mouse_install();
  vga_init();
  draw_vga();
}
