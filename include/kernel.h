#ifndef KERNEL_H
#define KERNEL_H

/* MAIN.C */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern char *memset(char *dest, char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern int strlen(const char *str);
extern unsigned char inportb (unsigned short _port);
extern void outportb (unsigned short _port, unsigned char _data);
/* Scrn.c */
extern void cls();
extern void putch(unsigned char c);
extern void puts(unsigned char *str);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);
extern void init_video();

/* gdt.c */
extern void gdt_install();
extern void gdt_flush();

/* idt.c */
extern void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);
extern void idt_install();

/* irs.c */
extern void isrs_install();
struct regs
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */ 
};

/* irq.c */
extern void irq_install();
extern void irq_install_handler(int irq, void (*handler)(struct regs *r));

/* timer.c */
extern void timer_install();

/* keyboard.c */
extern void keyboard_install();
#endif