#ifndef IRQ_H
#define IRQ_H

extern void irq_install();
extern void irq_install_handler(int irq, void (*handler)(struct regs *r));

#endif