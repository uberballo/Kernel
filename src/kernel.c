#include  "kernel.h"



/* This is a very simple main() function. All it does is sit in an
*  infinite loop. This will be like our 'idle' loop */
void main()
{
    /* You would add commands after here */
  gdt_install();
  idt_install();
  isrs_install();
  irq_install();
  asm volatile ("sti"); // Set interrupt flag
  init_video();
  timer_install();
  keyboard_install();
  puts("hello world");
  update_time(0);
  mouse_install();
  //int a = 1;
    /* ...and leave this loop in. There is an endless loop in
    *  'start.asm' also, if you accidentally delete this next line */
   // for (;;);
}
		