#include "mouse.h"
#include "utils.h"
#include "scrn.h"
#include "irq.h"
#include "types.h"


#define MOUSE_IRQ 12

#define MOUSE_PORT   0x60
#define MOUSE_STATUS 0x64
#define MOUSE_ABIT   0x02
#define MOUSE_BBIT   0x01
#define MOUSE_WRITE  0xD4
#define MOUSE_F_BIT  0x20
#define MOUSE_V_BIT  0x08

uint8 mouse_cycle = 0;
sint8 mouse_byte[3];


void mouse_wait(uint8 a_type) {
	uint32 timeout = 100000;
	if (!a_type) {
		while (--timeout) {
			if ((inportb(MOUSE_STATUS) & MOUSE_BBIT) == 1) {
				return;
			}
		}
		return;
	} else {
		while (--timeout) {
			if (!((inportb(MOUSE_STATUS) & MOUSE_ABIT))) {
				return;
			}
		}
		return;
	}
}

void mouse_write(uint8 write) {
	mouse_wait(1);
	outportb(MOUSE_STATUS, MOUSE_WRITE);
	mouse_wait(1);
	outportb(MOUSE_PORT, write);
}

uint8 mouse_read() {
	mouse_wait(0);
	char t = inportb(MOUSE_PORT);
	return t;
}


void mouse_handler(struct regs *r) {
	uint8 status = inportb(MOUSE_STATUS);
	while (status & MOUSE_BBIT) {
		sint8 mouse_in = inportb(MOUSE_PORT);
		if (status & MOUSE_F_BIT) {
			switch (mouse_cycle) {
				case 0:
					mouse_byte[0] = mouse_in;
					if (!(mouse_in & MOUSE_V_BIT)) return;
					++mouse_cycle;
					break;
				case 1:
					mouse_byte[1] = mouse_in;
					++mouse_cycle;
					break;
				case 2:
					mouse_byte[2] = mouse_in;

					if (mouse_byte[0] & 0x01) {
						puts("left");
					}
					if (mouse_byte[0] & 0x02) {
						puts("right");
					}
					if (mouse_byte[0] & 0x04) {
						puts("middle");
					}
					mouse_cycle = 0;

					break;
			}
		}
		status = inportb(MOUSE_STATUS);
	}
	irq_ack(MOUSE_IRQ);
}

void mouse_install() {
	uint8 status;
	IRQ_OFF;
	mouse_wait(1);
	outportb(MOUSE_STATUS, 0xA8);
	mouse_wait(1);
	outportb(MOUSE_STATUS, 0x20);
	mouse_wait(0);
	status = inportb(0x60) | 2;
	mouse_wait(1);
	outportb(MOUSE_STATUS, 0x60);
	mouse_wait(1);
	outportb(MOUSE_PORT, status);
	mouse_write(0xF6);
	mouse_read();
	mouse_write(0xF4);
	mouse_read();
	IRQ_RES;
	irq_install_handler(MOUSE_IRQ, mouse_handler);
}