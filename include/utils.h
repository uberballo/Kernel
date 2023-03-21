#ifndef UTILS_H
#define UTILS_H


extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern char *memset(char *dest, char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern int strlen(const char* str);
extern int digit_count(int num);
extern void itoa(int num, char *number);
extern unsigned char inportb (unsigned short _port);
extern void outportb (unsigned short _port, unsigned char _data);

#endif
