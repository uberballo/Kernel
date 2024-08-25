#include "utils.h"
#include "scrn.h"
#include "stdint.h"

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed char sint8;
typedef signed short sint16;
typedef signed int sint32;
typedef uint8 byte;
typedef uint16 word;
typedef uint32 dword;

unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count)
{
  /* Add code here to copy 'count' bytes of data from 'src' to
   *  'dest', finally return 'dest' */
  for (int i = 0; i < count; i++)
  {
    dest[i] = src[i];
  };
  return dest;
}

char *memset(char *dest, char val, int count)
{
  /* Add code here to set 'count' bytes in 'dest' to 'val'.
   *  Again, return 'dest' */
  for (int i = 0; i < count; i++)
  {
    dest[i] = val;
  };
  return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count)
{
  /* Same as above, but this time, we're working with a 16-bit
   *  'val' and dest pointer. Your code can be an exact copy of
   *  the above, provided that your local variables if any, are
   *  unsigned short */
  for (int i = 0; i < count; i++)
  {
    dest[i] = val;
  };
  return dest;
}

int strlen(const char *str)
{
  /* This loops through character array 'str', returning how
   *  many characters it needs to check before it finds a 0.
   *  In simple words, it returns the length in bytes of a string */
  int length = 0;
  while (str[length])
    length++;
  return length;
}

int digit_count(int num)
{
  int count = 0;
  if (num == 0)
    return 1;
  while (num > 0)
  {
    count++;
    num = num / 10;
  }
  return count;
}

void itoa(int num, char *number)
{
  int dgcount = digit_count(num);
  int index = dgcount - 1;
  char x;
  if (num == 0 && dgcount == 1)
  {
    number[0] = '0';
    number[1] = '\0';
  }
  else
  {
    while (num != 0)
    {
      x = num % 10;
      number[index] = x + '0';
      index--;
      num = num / 10;
    }
    number[dgcount] = '\0';
  }
}

/* We will use this to write to I/O ports to send bytes to devices. This
 *  will be used in the next tutorial for changing the textmode cursor
 *  position. Again, we use some inline assembly for the stuff that simply
 *  cannot be done in C */
void outportb(unsigned short _port, unsigned char _data)
{
  __asm__ __volatile__("outb %1, %0" : : "dN"(_port), "a"(_data));
}

/* We will use this later on for reading from the I/O ports to get data
 *  from devices such as the keyboard. We are using what is called
 *  'inline assembly' in these routines to actually do the work */
unsigned char inportb(unsigned short _port)
{
  unsigned char rv;
  __asm__ __volatile__("inb %1, %0" : "=a"(rv) : "dN"(_port));
  return rv;
}

void itoa2(char *buf, int base, int d)
{
  char *p = buf;
  char *p1, *p2;
  unsigned long ud = d;
  int divisor = 10;

  /* If %d is specified and D is minus, put ‘-’ in the head. */
  if (base == 'd' && d < 0)
  {
    *p++ = '-';
    buf++;
    ud = -d;
  }
  else if (base == 'x')
    divisor = 16;

  /* Divide UD by DIVISOR until UD == 0. */
  do
  {
    int remainder = ud % divisor;
    *p++ = (remainder < 10) ? remainder + '0' : remainder + 'a' - 10;
  } while (ud /= divisor);

  /* Terminate BUF. */
  *p = 0;

  /* Reverse BUF. */
  p1 = buf;
  p2 = p - 1;
  while (p1 < p2)
  {
    char tmp = *p1;
    *p1 = *p2;
    *p2 = tmp;
    p1++;
    p2--;
  }
}

void printf(const char *format, ...)
{
  char **arg = (char **)&format;
  int c;
  char buf[32];

  arg++;

  memset(buf, 0, sizeof(buf));
  while ((c = *format++) != 0)
  {
    if (c != '%')
      putch(c);
    else
    {
      char *p, *p2;
      int pad0 = 0, pad = 0;

      c = *format++;
      if (c == '0')
      {
        pad0 = 1;
        c = *format++;
      }

      if (c >= '0' && c <= '9')
      {
        pad = c - '0';
        c = *format++;
      }

      switch (c)
      {
      case 'd':
      case 'u':
      case 'x':
        itoa2(buf, c, *((int *)arg++));
        p = buf;
        goto string;
        break;

      case 's':
        p = *arg++;
        if (!p)
          p = "(null)";

      string:
        for (p2 = p; *p2; p2++)
          ;
        for (; p2 < p + pad; p2++)
          putch(pad0 ? '0' : ' ');
        while (*p)
          putch(*p++);
        break;

      default:
        putch(*((int *)arg++));
        break;
      }
    }
  }
}

float64_t sin(float64_t x)
{
  float64_t sinval;
  asm("fsin" : "=t"(sinval) : "0"(x));
  return sinval;
}

float64_t cos(float64_t x)
{
  float64_t cosval;
  asm("fcos" : "=t"(cosval) : "0"(x));
  return cosval;
}

static uint32_t rseed = 1;

void seed(uint32_t s)
{
  rseed = s;
}

uint32_t rand()
{
  static uint32_t x = 123456789;
  static uint32_t y = 362436069;
  static uint32_t z = 521288629;
  static uint32_t w = 88675123;

  x *= 23786259 - rseed;

  uint32_t t;

  t = x ^ (x << 11);
  x = y;
  y = z;
  z = w;
  w = w ^ (w >> 19) ^ t ^ (t >> 8);

  return w;
}
